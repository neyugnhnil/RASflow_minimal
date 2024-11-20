# depends: wget, csvkit, sratoolkit

# METAFILE ######################################################

wget -O configs/metadata.sdrf.txt https://ftp.ebi.ac.uk/biostudies/fire/E-MTAB-/567/E-MTAB-567/Files/E-MTAB-567.sdrf.txt

csvcut -t -c "Comment[ENA_RUN],FactorValue [sampling site],Characteristics[individual]" configs/metadata.sdrf.txt > configs/less_metadata.sdrf.txt

echo -e "sample\tgroup\tsubject" > ./configs/metafile.tsv

tail -n +2 configs/less_metadata.sdrf.txt | sort | uniq | sed 's/,/\t/g' - | cat - >> ./configs/metafile.tsv

## test ##

grep -E "ERR031031|ERR031032" ./configs/metafile.tsv > ./configs/test_metafile.tsv

# READSPATH ######################################################

mkdir -p ./data/raw/
mkdir ./data/raw/fastq_raws

## run list
cut -f1 ./configs/metafile.tsv | tail +2  | cat > run_list.txt
cut -f1 ./configs/test_metafile.tsv | tail +2  | cat > test_run_list.txt

## get reads
while read accession; do
    prefetch -O ./data/raw ${accession}
    fasterq-dump --split-files ./data/raw/${accession} -O ./data/raw/fastq_raws
done < ./data/raw/run_list.txt

# REFERENCE ######################################################

mkdir -p ./data/genome
wget -O data/genome/chr_Y.fa.gz ftp://ftp.ensembl.org/pub/release-113/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.Y.fa.gz
wget -O data/genome/annotations.gtf.gz ftp://ftp.ensembl.org/pub/release-113/gtf/homo_sapiens/Homo_sapiens.GRCh38.113.gtf.gz

gunzip data/genome/annotations.gtf.gz
gunzip data/genome/chr_Y.fa.gz

## test-only! ##

grep -P '^Y\t' data/genome/annotations.gtf > data/genome/Y_annotations.gtf
