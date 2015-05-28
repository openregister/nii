URL='https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/254174/20131031_NII_data.CSV' 
TIDDLERS='./nii/tiddlers/nii/'

.PHONY: seed

serve:
	tiddlywiki nii --server

seed:	nii.csv
	mkdir -p $(TIDDLERS)
	./seed.pl $(TIDDLERS) < nii.csv

nii.csv:
	curl $(URL) -z nii.csv -o nii.csv --silent --location
