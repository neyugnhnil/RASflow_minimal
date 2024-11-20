#!/bin/bash
#SBATCH --job-name=RASflow_test
#SBATCH -N 1
#SBATCH -c 8
#SBATCH --t = 12:00:00
#SBATCH --partition=courses
#SBATCH --mem=108G

#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=nguyen.ngocli@northeastern.edu
#SBATCH --output=slurm_logs/%x_%j.out
#SBATCH --error=slurm_logs/%x_%j.err

# setup environment

module load miniconda3/23.11.0

source activate RASflow

pip install csvkit

# snakemake environment stuff

module load sratoolkit/3.0.2
module load samtools/1.9
module load fastqc/0.11.8
module load salmon/1.0.0
module load trimgalore/0.6.4

# run

cd $HOME/RASflow_minimal

bash get_RASflow_data.sh
