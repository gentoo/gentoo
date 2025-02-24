# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: dkms.eclass
# @MAINTAINER:
# Nowa Ammerlaan <nowa@gentoo.org>
# @AUTHOR:
# Author: Nowa Ammerlaan <nowa@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: Helper eclass to manage DKMS modules
# @DESCRIPTION:
# Registers, builds and installs kernel modules using the DKMS
# (Dynamic Kernel Module Support) system provided by sys-kernel/dkms.
#
# The dkms_autoconf may be used to translate the modlist and modargs
# arrays from linux-mod-r1.eclass to a DKMS configuration file.
#
# If the upstream sources already contain a DKMS configuration file
# this may be used instead of the dkms_autoconf function. In this
# case the ebuild is responsible for using sed to ensure the make
# command(s) in the dkms.conf respect the users flags and compiler
# preferences (i.e. MODULES_MAKEARGS and MAKEOPTS).
#
# The eclass exports a src_install function that finds any dkms.conf
# files and installs the associated package. The pkg_postinst and
# pkg_postrm functions then take care of (de)registering,
# (un)building, removing, and/or adding the DKMS packages.
#
# For convenience the eclass also exports a pkg_config function that
# rebuilds and reinstalls any DKMS packages the ebuild owns.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_DKMS_ECLASS} ]]; then
_DKMS_ECLASS=1

IUSE="dkms"

RDEPEND="dkms? ( sys-kernel/dkms )"
IDEPEND="dkms? ( sys-kernel/dkms )"

# @ECLASS_VARIABLE: DKMS_PACKAGES
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# After dkms_src_install or dkms_dopackage this array will be
# populated with all dkms packages installed by the ebuild. The names
# and versions of each package are separated with a ':'.
DKMS_PACKAGES=()

# @FUNCTION: dkms_autoconf
# @DESCRIPTION:
# Uses linux-mod-r1's modlist and modargs to construct a DKMS
# configuration file. This function should be called *after*
# linux-mod-r1_src_compile. Does nothing if USE=dkms is disabled.
dkms_autoconf() {
	use dkms || return
	[[ ${#modlist[@]} -lt 1 ]] && die "modlist unset or empty"
	local arg dkms_build_args index mod name package
	for mod in "${modlist[@]}"; do
		name=${mod%%=*}
		[[ -n ${name} && ${name} != *:* ]] ||
			die "invalid mod entry '${mod}'"

		# 0:install-dir 1:source-dir 2:build-dir 3:make-target(s)
		mod=${mod#"${name}"}
		IFS=: read -ra mod <<<"${mod#=}"
		[[ ${#mod[@]} -le 4 ]] ||
			die "too many ':' in ${name}'s modlist"

		local -a emakeargs=( "${MODULES_MAKEARGS[@]}" )
		[[ ${modargs@a} == *a* ]] && emakeargs+=( "${modargs[@]}" )
		dkms_build_args=()
		for arg in "${emakeargs[@]}"; do
			if [[ ${arg} == *${KV_FULL}* || ${arg} == *${KV_DIR}* ||
				${arg} == *${KV_OUT_DIR}* ]]
			then
				# Skip arguments pointing to the current kernel target
				continue
			fi
			if [[ ${arg} == *=* ]]; then
				# Quote values for variables to avoid parsing problems
				dkms_build_args+=( "${arg%%=*}='${arg#*=}'" )
			else
				dkms_build_args+=( "${arg}" )
			fi
		done

		pushd "${mod[1]}" >/dev/null || die
		if [[ -f dkms.conf ]]; then
			# If the module already exists in the dkms.conf, skip
			# otherwise find the first available index.
			if grep -q "^MAKE\[0\]=" dkms.conf; then
				# Check if make command already respecting our options.
				# If not, sed our options in for all MAKE[#].
				if ! grep -q "^MAKE\[0\]=.*${MAKEOPTS}.*${dkms_build_args[*]}" dkms.conf
				then
					sed -i dkms.conf \
						-e "/^MAKE/ s:make :make ${MAKEOPTS} ${dkms_build_args[*]}:" \
						-e "/^MAKE/ s:'make' :'make' ${MAKEOPTS} ${dkms_build_args[*]}:" ||
							die "Failed to sed existing dkms.conf"
				fi
			else
				echo "MAKE[0]=\"make ${MAKEOPTS} ${dkms_build_args[*]} ${mod[3]}\"" \
					>> dkms.conf || die
			fi

			# Find the index of an existing module, else find the
			# first available index.
			index=$(
				source dkms.conf &>/dev/null || die "invalid dkms.conf"
				local i
				for i in "${!BUILT_MODULE_NAME[@]}"; do
					if [[ ${name} == ${BUILT_MODULE_NAME[${i}]} ]]
					then
						echo ${i} || die
						exit
					fi
				done
				echo ${#BUILT_MODULE_NAME[@]} || die
			) || continue
		else
			# If the kernel modules are in a subdir add this to the
			# DKMS package name identifier to ensure it is unique.
			# There may be multiple subdirs with kernel modules.
			if [[ ${PWD} == ${S} ]]; then
				package=${PN}
			else
				package=${PN}_${name}
			fi
			cat <<-EOF > dkms.conf || die
				PACKAGE_NAME=${package}
				PACKAGE_VERSION=${PV}
				AUTOINSTALL=yes
				MAKE[0]="make ${MAKEOPTS} ${dkms_build_args[*]} ${mod[3]}"
			EOF
			index=0
		fi

		# DKMS enforces that the install target starts with one of
		# these options.
		local dest=${mod[0]}
		if ! [[ ${dest} == /kernel* || ${dest} == /updates* ||
			${dest} == /extra* ]]
		then
			dest=/extra/${dest}
		fi
		cat <<-EOF >> dkms.conf || die
			BUILT_MODULE_NAME[${index}]=${name}
			BUILT_MODULE_LOCATION[${index}]=.${mod[2]#"${mod[1]}"}/
			DEST_MODULE_NAME[${index}]=${name}
			DEST_MODULE_LOCATION[${index}]=${dest}
		EOF
		# Find stripping preferences based on USE flag or FEATURES
		if in_iuse strip; then
			if use strip; then
				echo "STRIP[${index}]=yes" >> dkms.conf || die
			else
				echo "STRIP[${index}]=no" >> dkms.conf || die
			fi
		else
			if has nostrip ${FEATURES}; then
				echo "STRIP[${index}]=no" >> dkms.conf || die
			else
				echo "STRIP[${index}]=yes" >> dkms.conf || die
			fi
		fi

		popd >/dev/null || die
	done
}

# @FUNCTION: dkms_dopackage
# @USAGE: <directory containing dkms.conf>
# @DESCRIPTION:
# Installs a DKMS package to ${ED}/usr/src. If no path is specified
# as the first argument, then the root of the package is assumed to
# be the pwd. Appends the installed package to the global
# DKMS_PACKAGES array. Does nothing if USE=dkms is disabled.
dkms_dopackage() {
	use dkms || return
	[[ ${#} -gt 1 ]] && die "dkms_dopackage: too many arguments"
	local package_root=${1:=.}
	[[ -f ${package_root}/dkms.conf ]] ||
		die "No DKMS configuration file at ${package_root}!"
	# subshell to avoid changing the insinto globally and polluting
	# the environment with the dkms.conf.
	local package="$(
		source "${package_root}/dkms.conf" &>/dev/null ||
			die "Invalid DKMS configuration file at ${package_root}!"
		insinto "/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}"
		doins -r "${package_root}"/*
		echo "${PACKAGE_NAME}:${PACKAGE_VERSION}"
	)"
	if has "${package}" "${DKMS_PACKAGES[@]}"; then
		die "DKMS package with the same name is already installed"
	else
		DKMS_PACKAGES+=( "${package}" )
	fi
}

# @FUNCTION: dkms_src_install
# @DESCRIPTION:
# Runs dkms_dopackage for each dkms.conf found in the pwd or any
# sub-directories. Does nothing if USE=dkms is disabled.
dkms_src_install() {
	use dkms || return
	while IFS= read -r -d '' file; do
		dkms_dopackage $(dirname "${file}")
	done < <(find . -type f -name dkms.conf -print0)
}

# @FUNCTION: dkms_pkg_config
# @DESCRIPTION:
# Rebuilds and reinstalls all DKMS packages owned by the ebuild. Does
# nothing if USE=dkms is disabled.
dkms_pkg_config() {
	use dkms || return
	local package
	for package in "${DKMS_PACKAGES[@]}"; do
		IFS=: read -ra package <<<"${package#}"
		[[ ${#package[@]} -eq 2 ]] ||
			die "incorrect package=${package}"
		dkms build -m ${package[0]} -v ${package[1]} --force ||
			die "Failed to build ${package} with DKMS"
		dkms install -m ${package[0]} -v ${package[1]} --force ||
			die "Failed to install ${package} with DKMS"
	done
}

# @FUNCTION: dkms_postinst
# @DESCRIPTION:
# Registers, builds and installs all DKMS packages owned by the
# ebuild. Does nothing if USE=dkms is disabled.
dkms_pkg_postinst() {
	use dkms || return
	local package
	for package in "${DKMS_PACKAGES[@]}"; do
		IFS=: read -ra package <<<"${package#}"
		[[ ${#package[@]} -eq 2 ]] ||
			die "incorrect package=${package}"
		dkms add -m ${package[0]} -v ${package[1]} ||
			die "Failed to register ${package} with DKMS"
		dkms build -m ${package[0]} -v ${package[1]} \
			${KV_FULL:+-k ${KV_FULL}} --force ||
				die "Failed to build ${package} with DKMS"
		dkms install -m ${package[0]} -v ${package[1]} \
			${KV_FULL:+-k ${KV_FULL}} --force ||
			die "Failed to install ${package} with DKMS"
	done
}

# @FUNCTION: dkms_pkg_prerm
# @DESCRIPTION:
# Uninstalls, unbuilds and deregisters all DKMS packages owned by the
# ebuild. Does nothing if USE=dkms is disabled.
dkms_pkg_prerm() {
	use dkms || return
	local package
	for package in "${DKMS_PACKAGES[@]}"; do
		IFS=: read -ra package <<<"${package#}"
		[[ ${#package[@]} -eq 2 ]] ||
			die "incorrect package=${package}"
		dkms uninstall -m ${package[0]} -v ${package[1]} --all ||
			ewarn "Failed to uninstall ${package} with DKMS"
		dkms unbuild -m ${package[0]} -v ${package[1]} --all ||
			ewarn "Failed to unbuild ${package} with DKMS"
		dkms remove -m ${package[0]} -v ${package[1]} --all ||
			ewarn "Failed to deregister ${package} with DKMS"
	done
}

EXPORT_FUNCTIONS src_install pkg_config pkg_postinst pkg_prerm

fi
