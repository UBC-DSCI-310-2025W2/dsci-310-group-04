
data/online_shoppers_purchasing_intention_dataset.csv: 
	Rscript src/data_loading.R \
			--input_url="https://archive.ics.uci.edu/static/public/468/online+shoppers+purchasing+intention+dataset.zip" \
		    --output_file_path="data/raw/online_shoppers_purchasing_intention_dataset.csv"
