#!/bin/bash
#SBATCH --job-name=RASflow_test
#SBATCH -N 1
#SBATCH -c 8
#SBATCH --time=12:00:00
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

module load sratoolkit/3.0.2

cd $HOME/RASflow_minimal

bash get_RASflow_data.sh
