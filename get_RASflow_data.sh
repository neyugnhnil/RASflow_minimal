#!/bin/bash

mkdir data logs input output

# METAFILE ######################################################

wget -O configs/metadata.sdrf.txt https://ftp.ebi.ac.uk/biostudies/fire/E-MTAB-/567/E-MTAB-567/Files/E-MTAB-567.sdrf.txt

echo -e "sample\tgroup\tsubject" > ./configs/metafile.tsv

csvcut -t -c "Comment[ENA_RUN],FactorValue [sampling site],Characteristics[individual]" configs/metadata.sdrf.txt > configs/less_metadata.sdrf.txt

tail -n +2 configs/less_metadata.sdrf.txt | sort | uniq | sed 's/,/\t/g' - | cat - >> ./configs/metafile.tsv

## test ##

grep -E "sample|ERR031031|ERR031032" ./configs/metafile.tsv > ./configs/test_metafile.tsv

# READSPATH ######################################################

mkdir -p ./data/raw/fastq_raws

## run list
cut -f1 ./configs/metafile.tsv | tail -n +2  | cat > ./configs/run_list.txt
cut -f1 ./configs/test_metafile.tsv | cat > ./configs/test_run_list.txt

## get reads

while read accession; do
    prefetch -O ./data/raw ${accession}
    fasterq-dump --split-files ./data/raw/${accession} -O ./data/raw/fastq_raws
    gzip ./data/raw/fastq_raws/${accession}_1.fastq
    gzip ./data/raw/fastq_raws/${accession}_2.fastq
    rm -r ./data/raw/${accession}
done < ./configs/test_run_list.txt

# REFERENCE ######################################################

mkdir -p ./data/genome

## human genome
wget -O data/genome/GRCh38.fa.gz wget ftp://ftp.ensembl.org/pub/release-113/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
gunzip data/genome/GRCh38.fa.gz

## annotations
wget -O data/genome/annotations.gtf.gz ftp://ftp.ensembl.org/pub/release-113/gtf/homo_sapiens/Homo_sapiens.GRCh38.113.gtf.gz
gunzip data/genome/annotations.gtf.gz
