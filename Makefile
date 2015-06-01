URL='https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/254174/20131031_NII_data.CSV' 
TIDDLERS='./nii/tiddlers/nii/'
INDEX=static/output/index.html

.PHONY: seed serve build deploy

build:
	tiddlywiki static --build

serve:
	tiddlywiki nii --server

deploy:	$(INDEX)
	scp $(INDEX) dh:whatfettle.com/2015/05/nii.html

# bootstrap from the CSV
seed:	nii.csv
	mkdir -p $(TIDDLERS)
	seed/seed.pl $(TIDDLERS) < seed/nii.csv

nii.csv:
	curl $(URL) -z nii.csv -o nii.csv --silent --location
