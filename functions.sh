set -u

function sandbox_container_exists () {
	docker inspect "$(get_sandbox_name)" 2>/dev/null 1>/dev/null
}

function get_sandbox_name () {
	pwd | sed 's/^\//docksand-/g' |  tr '/' '-' | tr '[:upper:]' '[:lower:]'
}

function create_sandbox_image_tag () {
	echo "$(get_sandbox_name):$(date +'%s')"
}

function list_sandbox_images () {
	docker images "$(get_sandbox_name)"
}

function list_sandbox_container () {
	docker ps -a --filter "name=$(get_sandbox_name)"
}

function get_base_image_root () {
	echo "${BASE_IMAGE_ROOT}"
}

function create_base_image () {
	(
		set -e
		local sandbox_image_tag=$(create_sandbox_image_tag)
		docker create --workdir "${SANDBOX_WORKDIR}" --entrypoint "${SANDBOX_ENTRYPOINT}" --name "tmp_sandbox_base" "$(get_base_image_root)" >/dev/null
		docker commit "tmp_sandbox_base" "${sandbox_image_tag}" >/dev/null
		docker rm "tmp_sandbox_base" >/dev/null
		echo "$sandbox_image_tag";
	)
}

function get_most_recent_sandbox_image_tag () {
	(
		local possible_latest=$(docker images $(get_sandbox_name) --format "{{.Tag}}" | sort -n |awk '/./{line=$0} END{print line}');
		if [[ "${possible_latest}" == "" ]]; then
			echo "$(create_base_image)"
		else
			echo "$(get_sandbox_name):${possible_latest}"
		fi
	)
}

function create_new_sandbox_image () {
	docker commit "$(get_sandbox_name)" "$(create_sandbox_image_tag)"
}

function get_image_workdir () {
	docker inspect --format='{{.Config.WorkingDir}}' $1
}

function create_new_sandbox_container () {
	local sandbox_image_tag=$(get_most_recent_sandbox_image_tag);
	local sandbox_workdir=$(get_image_workdir ${sandbox_image_tag})
	docker create -it -v "$(pwd):/${sandbox_workdir}" --name "$(get_sandbox_name)" "${sandbox_image_tag}"
}

function remove_sandbox_images () {
	local image_ids=$(docker images -q $(get_sandbox_name))
	if [[ ! -z "${image_ids}" ]]; then
		docker rmi -f $(docker images -q $(get_sandbox_name))
	fi
}

function remove_sandbox_container () {
	docker rm "$(get_sandbox_name)"
}

function start_sandbox_container () {
	docker start -i "$(get_sandbox_name)"
}

function remove_sandbox () {
	(
		set -e
		if sandbox_container_exists; then
			remove_sandbox_container >/dev/null
		fi
		remove_sandbox_images >/dev/null
	)
}
