import argparse
from decimal import Decimal

import numpy as np
import pandas as pd
from tqdm import tqdm


def validate(df: pd.DataFrame):
    """
    validate the frequencies of a site equal to 1

    :param df:Dataframe of frequency
    """

    sum_freq = df.groupby(df.index)["AF"].sum()
    invalid_sites = sum_freq[sum_freq != 1].index

    if len(invalid_sites) > 0:
        print(
            f"The sum of all genotype frequencies at these sites is not equal to 1: {invalid_sites}"
        )

def people_accordingToFrequency(df: pd.DataFrame, name: str):
    """
    random generate a people according frequency

    :param df:Dataframe of fre
    """
    df["AF_normalized"] = df.groupby(df.index)["AF"].transform(lambda x: x / x.sum())
    people = (
        df.groupby(df.index)
        .apply(
            lambda x: pd.Series(
                {
                    "genotype1": np.random.choice(x["genotype"], p=x["AF_normalized"]),
                    "genotype2": np.random.choice(x["genotype"], p=x["AF_normalized"]),
                }
            )
        )
        .reset_index()
    )
    people.insert(0, "name", name)

    return people

def offspring(father: pd.DataFrame, mother: pd.DataFrame, name: str):
    """
    random generate a people according

    :param father
    :param mother, The order of the sites should be consistent
    """

    people = father.copy()
    people["genotype1"] = father[["genotype1", "genotype2"]].apply(
        lambda x: np.random.choice(x), axis=1
    )
    people["genotype2"] = mother[["genotype1", "genotype2"]].apply(
        lambda x: np.random.choice(x), axis=1
    )
    people.drop("name", axis=1, inplace=True)
    people.insert(0, "name", name)

    return people

def convert_to_float128(value):
    try:
        return np.float128(value)
    except:
        return value

def pedigree(df, file, file_save):
    ids = pd.read_csv(file, sep="\t", header=None, dtype=str)
    ls = {}
    progress_bar = tqdm(range(ids.shape[0]), position=0)
    for _, id in ids.iterrows():
        individual = id[0]
        father = id[1]
        mother = id[2]

        # 为了处理family文件中出现Nan的情况
        if father in ls and father != None:
            pass
        else:
            ls[father] = people_accordingToFrequency(df, father)

        if mother in ls and mother != None:
            pass
        else:
            ls[mother] = people_accordingToFrequency(df, mother)

        if not pd.isna(father):
            ls[individual] = offspring(ls[father], ls[mother], individual)
        progress_bar.update()
    progress_bar.close()

    merge_df = pd.concat([i for i in ls.values()])

    all_ids = ids[0].to_list() + ids[1].to_list() + ids[2].to_list()
    if set(merge_df["name"]).difference(set(all_ids)) != set():
        print("something wrong!")
    merge_df.dropna().to_csv(file_save, index=None, header=None, sep="\t")

    return merge_df, all_ids

def family(file_save_prefix: str, num_repeats: int = 3):
    dic = []
    for i in range(1, num_repeats + 1):
        dic.append([f'F1_{i}',"",""])
        dic.append([f'F2_{i}',"",""])
        dic.append([f'F3_{i}',"",""])
        dic.append([f'M1_{i}',"",""])
        dic.append([f'M2_{i}',"",""])
        dic.append([f'M3_{i}',"",""])

        dic.append([f's1_{i}',f'F1_{i}',f'M1_{i}'])
        dic.append([f's2_{i}',f'F1_{i}',f'M1_{i}'])
        dic.append([f's3_{i}',f'F2_{i}',f'M2_{i}'])
        dic.append([f's4_{i}',f'F2_{i}',f'M2_{i}'])
        dic.append([f's5_{i}',f'F3_{i}',f'M3_{i}'])
        dic.append([f's6_{i}',f'F3_{i}',f'M3_{i}'])

        dic.append([f'g1_{i}',f's2_{i}',f's3_{i}'])
        dic.append([f'g2_{i}',f's2_{i}',f's3_{i}'])
        dic.append([f'g3_{i}',f's4_{i}',f's5_{i}'])
        dic.append([f'g4_{i}',f's4_{i}',f's5_{i}'])

        dic.append([f'c1_{i}',f'g1_{i}',f'random1_{i}'])
        dic.append([f'c2_{i}',f'g4_{i}',f'random2_{i}'])
        
        
    result = pd.DataFrame(dic)

    file_save = f'{file_save_prefix}'
    result.to_csv(file_save, index=None, header=None, sep="\t")
    return None

def main():
    parser = argparse.ArgumentParser(description="simulate")
    parser.add_argument("--frequency", type=str, help="frequency")
    parser.add_argument("--nums", type=int, default=2500, help="number of family")
    parser.add_argument("--familys", type=str, help="save path of familys")
    parser.add_argument("--output", type=str, help="save path of data")
    args = parser.parse_args()

    family(args.familys, args.nums)
    
    df = pd.read_csv(args.frequency, sep="\t", header=None, dtype=str)
    df.columns = ["id", "genotype", "AF"]
    df.set_index("id", inplace=True)
    df["AF"] = df["AF"].apply(convert_to_float128)
    merge_df, all_ids = pedigree(df, args.familys, args.output)

if __name__ == "__main__":
    main()

    