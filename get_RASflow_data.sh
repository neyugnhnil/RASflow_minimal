#!/bin/bash

#  directories
mkdir -p data/raw/fastq_raws data/genome configs logs input output

#  metadata
wget -q -O configs/metadata.sdrf.txt https://ftp.ebi.ac.uk/biostudies/fire/E-MTAB-/567/E-MTAB-567/Files/E-MTAB-567.sdrf.txt
echo -e "sample\tgroup\tsubject" > configs/metafile.tsv
csvcut -t -c "Comment[ENA_RUN],FactorValue [sampling site],Characteristics[individual]" configs/metadata.sdrf.txt | \
    tail -n +2 | sort | uniq | sed 's/,/\t/g' >> configs/metafile.tsv

# run list
cut -f1 configs/metafile.tsv | tail -n +2 > configs/run_list.txt

# raw reads
while read accession; do
    prefetch -O data/raw "${accession}" && \
    fasterq-dump --split-files data/raw/"${accession}" -O data/raw/fastq_raws && \
    gzip data/raw/fastq_raws/"${accession}"_{1,2}.fastq && \
    rm -r data/raw/"${accession}"
done < configs/run_list.txt

# ref and annotations
wget -q -O data/genome/GRCh38.fa.gz ftp://ftp.ensembl.org/pub/release-113/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
wget -q -O data/genome/annotations.gtf.gz ftp://ftp.ensembl.org/pub/release-113/gtf/homo_sapiens/Homo_sapiens.GRCh38.113.gtf.gz
gunzip data/genome/*.gz
