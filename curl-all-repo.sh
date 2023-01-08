while getopts t:d:g:b: flag
do
    case "${flag}" in
        t) access_token=${OPTARG};;
        d) domain=${OPTARG};;
        g) group_id=${OPTARG};;
        b) branch=${OPTARG};;
    esac
done
dir="gitlab-$group_id-$branch"
mkdir $dir
touch ./$dir/projects.json
touch ./$dir/url.txt
touch ./$dir/clone_all.sh
curl --header "Private-Token: $access_token" --request GET "$domain/api/v4/groups/$group_id" > ./$dir/group.json
full_path=$(jq '.full_path' ./$dir/group.json | sed 's/"//g')
jq '.projects[].name' ./$dir/group.json | sed 's/"//g' > ./$dir/name.txt
while read -r NAME; do git clone --branch $branch $domain/$full_path/$NAME.git $dir/$NAME; done < ./$dir/name.txt
