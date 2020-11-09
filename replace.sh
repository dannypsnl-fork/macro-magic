new_proj_name=$1
new_github_name=$2 || 'dannypsnl'
new_authro_name=$3 || 'Lîm Tsú-thuàn'

# repo name
sed -i "" "s/racket-project/$new_proj_name/g" ./info.rkt
sed -i "" "s/racket-project/$new_proj_name/g" ./scribblings/racket-project.scrbl
sed -i "" "s/racket project/$new_proj_name/g" ./README.md

# author name
sed -i "" "s/dannypsnl/$new_github_name/g" ./info.rkt
sed -i "" "s/Lîm Tsú-thuàn/$new_author_name/g" ./scribblings/racket-project.scrbl

mv ./scribblings/racket-project.scrbl ./scribblings/$new_proj_name.scrbl
