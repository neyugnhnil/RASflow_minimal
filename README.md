# RASflow_minimal

## Running

Make sure to get up RASflow environment using `conda create -n RASflow -f env.yaml` and configure config_main.yaml before sending job (`sbatch run_RASflow_job.sh`).

By default this does genome alignment and DEA for subject 3 (ERR031031 normal tissue, ERR031032 tumor tissue). 

It is possible that you need to pre-install csvcut into the environment.

To change subject, edit get_RASflow_data.sh. Currently the sub-metafile representing what subject is being used is called "test_metafile".

## Info

How this repo was generated:

```bash
git clone --no-checkout --depth 1 https://github.com/zhxiaokang/RASflow RASflow_minimal

cd RASflow_minimal

git sparse-checkout init

cat > .git/info/sparse-checkout <<EOF

configs/config_main.yaml
configs/EnsemblDataSet_look_up_table.csv

scripts/*
!scripts/*cod*

env.yaml
main.py

workflow/*.rules
!workflow/*cod*
!workflow/*test*
EOF

git checkout master

cp ../get_RASflow_data.sh .
```
