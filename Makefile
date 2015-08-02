GOV_UK_URL='https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/254174/20131031_NII_data.CSV' 

TIDDLERS='./nii/tiddlers/nii/'
INDEX=nii/output/index.html
NOTES=nii/output/nii-notes.html

.PHONY: seed serve build deploy

build:
	tiddlywiki nii --build

serve:
	tiddlywiki server --server

deploy:	$(INDEX)
	scp $(INDEX) dh:whatfettle.com/2015/05/nii.html
	scp $(NOTES) dh:whatfettle.com/2015/05/nii-notes.html

# bootstrap from the CSV
seed:	nii.csv
	mkdir -p $(TIDDLERS)
	seed/seed.pl $(TIDDLERS) < seed/nii.csv

nii.csv:
	curl $(GOV_UK_URL) -z nii.csv -o nii.csv --silent --location

# this API call differs with results to http://data.gov.uk/data/search?core_dataset=true
DATA_GOV_UK_URL='http://data.gov.uk/api/3/action/package_search?q=core_dataset:true'
core.json:
	curl $(DATA_GOV_UK_URL) -z core.json -o core.json --silent --location
