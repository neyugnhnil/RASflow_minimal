# RASflow_minimal

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

mkdir data logs input

cp ../get_RASflow_data.sh .
```
