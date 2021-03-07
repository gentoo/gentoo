#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Author: Ralph Sennhauser <sera@gentoo.org>

die() {
	echo "${@}"
	exit 1
}

dir_is_empty() {
	# usage:
	#  dir_is_empty <some-dir>
	#
	# returns 2 if the dir does not even exist
	# returns 1 if the dir is not empty
	# returns 0 (success) if the dir exists and is empty

	local dir=$1
	local files

	if [[ ! -e ${dir} ]] ; then
		return 2
	fi

	shopt -s nullglob dotglob     # To include hidden files
	files=( "${dir}"/* )
	shopt -u nullglob dotglob

	if [[ ${#files[@]} -eq 0 ]]; then
		return 0
	else
		return 1
	fi

}

usage() {
	cat <<EOL
Usage: ${BASH_SOURCE} <--create|--remove|--help> [--suffix s][--user u][--group g]

  Options:
    --help:
      show this text.
    --create:
      create a new instance
    --remove:
      remove an existing instance.
    --suffix SUFFIX:
      a suffix for this instance. the suffix may not collide with an already
      existing instance, defaults to empty.
    --user USER:
      the user for which to configure this instance for. The user needs to
      exist already. defaults to tomcat.
    --group GROUP:
      the group for which to configure this instance for. The group needs to
      exist already. defaults to tomcat.

  Examples:
    ${BASH_SOURCE} --create --suffix testing --user tacmot --group tacmot
    ${BASH_SOURCE} --remove --suffix testing
EOL
}

parse_argv() {
	action="not specified"
	instance_name="tomcat-@SLOT@"
	instance_user="tomcat"
	instance_group="tomcat"

	while [[ -n $1 ]]; do
		case $1 in
			--help)
				usage
				exit 0;;
			--suffix)
				instance_name+="-$2"
				shift; shift;;
			--user)
				instance_user="$2"
				shift; shift;;
			--group)
				instance_group="$2"
				shift; shift;;
			--create)
				action=create
				shift;;
			--remove)
				action=remove
				shift;;
			--backup)
				action=backup
				shift;;
			--restore)
				action=restore
				shift;;
			--update)
				action=update
				shift;;
			*)
				echo "Invalid option '$1'"
				usage
				exit 2;;
		esac
	done

	tomcat_home="/@GENTOO_PORTAGE_EPREFIX@usr/share/tomcat-@SLOT@"
	instance_base="/@GENTOO_PORTAGE_EPREFIX@var/lib/${instance_name}"
	instance_conf="/@GENTOO_PORTAGE_EPREFIX@etc/${instance_name}"
	instance_logs="/@GENTOO_PORTAGE_EPREFIX@var/log/${instance_name}"
	instance_temp="/@GENTOO_PORTAGE_EPREFIX@var/tmp/${instance_name}"

	all_targets=(
		"${instance_base}"
		"${instance_logs}"
		"${instance_temp}"
		"/@GENTOO_PORTAGE_EPREFIX@etc/${instance_name}"
		"/@GENTOO_PORTAGE_EPREFIX@etc/init.d/${instance_name}"
		"/@GENTOO_PORTAGE_EPREFIX@etc/conf.d/${instance_name}"
	)
}
	
test_can_deploy() {
	local no_deploy target
	for target in "${all_targets[@]}"; do
		if [[ -e "${target}" ]]; then
			if ! dir_is_empty "${target}" ; then
				echo "Error: '${target}' already exists and is not empty."
				no_deploy=yes
			fi
		fi
	done
	if [[ -n "${no_deploy}" ]]; then
		cat <<-EOL

			To protect an existing installation no new instance was deployed. You can use
			'${BASH_SOURCE} --remove'
			to remove an existing instance first or run
			'${BASH_SOURCE} --create --sufix <instance_suffix>'
			to deploy an instance under a different name

		EOL
		usage
		exit 1
	fi

	if ! getent passwd | cut -d: -f1 | grep -Fx "${instance_user}" > /dev/null; then
		echo "Error: user '${instance_user}' doesn't exist."
		exit 1
	fi

	if ! getent group | cut -d: -f1 | grep -Fx "${instance_group}" > /dev/null; then
		echo "Error: group '${instance_group}' doesn't exist."
		exit 1
	fi
}

deploy_instance() {
	test_can_deploy

	mkdir -p "${instance_base}"/{work,webapps} || die
	mkdir -p "${instance_logs}" || die
	mkdir -p "${instance_temp}" || die
	mkdir -p "${instance_conf}" || die

	cp -r "${tomcat_home}"/webapps/ROOT "${instance_base}"/webapps || die

	chown -R "${instance_user}":"${instance_group}" \
		"${instance_base}" "${instance_logs}" "${instance_temp}" || die

	find "${instance_base}"/webapps -type d -exec chmod 750 {} + || die
	find "${instance_base}"/webapps -type f -exec chmod 640 {} + || die

	# initial config #

	cp -r "${tomcat_home}"/conf/* "${instance_conf}"/ || die

	sed -i -e "s|\${catalina.base}/logs|${instance_logs}|" \
		"${instance_conf}"/logging.properties || die
	sed -i -e "s|directory=\"logs\"|directory=\"${instance_logs}\"|" \
		"${instance_conf}"/server.xml || die

	mkdir -p "${instance_conf}"/Catalina/localhost || die
	cat > "${instance_conf}"/Catalina/localhost/host-manager.xml <<-'EOF'
		<?xml version="1.0" encoding="UTF-8"?>
		<Context docBase="${catalina.home}/webapps/host-manager"
				antiResourceLocking="false" privileged="true" />
	EOF

	cat > "${instance_conf}"/Catalina/localhost/manager.xml <<-'EOF'
		<?xml version="1.0" encoding="UTF-8"?>
		<Context docBase="${catalina.home}/webapps/manager"
				antiResourceLocking="false" privileged="true" />
	EOF

	if [[ -d "${tomcat_home}"/webapps/docs ]]; then
		cat > "${instance_conf}"/Catalina/localhost/docs.xml <<-'EOF'
			<?xml version="1.0" encoding="UTF-8"?>
			<Context docBase="${catalina.home}/webapps/docs" />
		EOF
	fi

	if [[ -d "${tomcat_home}"/webapps/examples ]]; then
		cat > "${instance_conf}"/Catalina/localhost/examples.xml <<-'EOF'
			<?xml version="1.0" encoding="UTF-8"?>
			<Context docBase="${catalina.home}/webapps/examples" />
		EOF
	fi

	chown -R "${instance_user}":"${instance_group}" "${instance_conf}" || die
	find "${instance_conf}" -type d -exec chmod 750 {} + || die
	find "${instance_conf}" -type f -exec chmod 640 {} + || die

	# rc script #

	cp "${tomcat_home}"/gentoo/tomcat.init \
		"/@GENTOO_PORTAGE_EPREFIX@etc/init.d/${instance_name}" || die

	sed -e "s|@INSTANCE_NAME@|${instance_name}|g" \
		-e "s|@INSTANCE_USER@|${instance_user}|g" \
		-e "s|@INSTANCE_GROUP@|${instance_group}|g" \
		"${tomcat_home}"/gentoo/tomcat.conf \
		> "/@GENTOO_PORTAGE_EPREFIX@etc/conf.d/${instance_name}" || die

	# some symlinks for tomcat and netbeans #

	ln -s "${instance_conf}" "${instance_base}"/conf || die
	ln -s "${instance_temp}" "${instance_base}"/temp || die

	# a note to update the default configuration #

	cat <<-EOL
		Successfully created instance '${instance_name}'
		It's strongly recommended for production systems to go carefully through the
		configuration files at '${instance_conf}'.
		The generated initial configuration is close to upstreams default which
		favours the demo aspect over hardening.
	EOL
}

remove_instance() {
	echo "The following files will be removed permanently:"
	local target; for target in "${all_targets[@]}"; do
		find ${target}
	done

	echo "Type 'yes' to continue"
	read
	if [[ ${REPLY} == yes ]]; then
		rm -rv "${all_targets[@]}"
	else 
		echo "Aborting as requested ..."
	fi
}

parse_argv "$@"

if [[ ${action} == create ]]; then
	deploy_instance
elif [[ ${action} == remove ]]; then
	remove_instance
elif [[ ${action} == "not specified" ]]; then
	echo "No action specified!"
	usage
	exit 1
else
	echo "${action} not yet implemented!"
	usage
	exit 1
fi
