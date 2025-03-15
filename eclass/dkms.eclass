# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: dkms.eclass
# @MAINTAINER:
# Nowa Ammerlaan <nowa@gentoo.org>
# @AUTHOR:
# Nowa Ammerlaan <nowa@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @PROVIDES: linux-mod-r1
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
# case dkms_gentoofy_conf function may be used to insert the users
# compiler, MAKEOPTS and *FLAGS preferences into the DKMS
# configuration file.
#
# The dkms_dopackage function is used to install a DKMS package, this
# function expects to find a dkms.conf file at the path specified
# by the argument passed to this function. If no path is specified
# then the current working directory is used.
#
# For convenience this eclass exports a src_compile function that runs
# dkms_autoconf if the dkms USE flag is enabled, and if the flag is
# disabled it runs linux-mod-r1_src_compile instead. Similarly,
# the src_install function exported by this eclass finds any
# dkms.conf files in the current working directory or one of its
# subdirectories and then calls dkms_dopackage for these packages.
# And if the dkms USE flag is disabled it runs
# linux-mod-r1_src_install instead.
#
# The pkg_postinst and pkg_postrm functions then take care of
# (de)registering, (un)building, removing, and/or adding the DKMS
# packages. For convenience the eclass also exports a pkg_config
# function that rebuilds and reinstalls any DKMS packages the ebuild
# owns for the currently running kernel.
#
# @EXAMPLE:
#
# To add DKMS support to an ebuild currently using only linux-mod-r1.
#
# Change:
#
# @CODE
# inherit linux-mod-r1
#
# src_compile() {
#     local modlist=(
#         gentoo
#         gamepad=kernel/drivers/hid:gamepad:gamepad/obj
#     )
#     local modargs=( NIH_SOURCE="${KV_OUT_DIR}" )
#
#     linux-mod-r1_src_compile
# }
# @CODE
#
# To:
#
# @CODE
# inherit dkms
#
# src_compile() {
#     local modlist=(
#         gentoo
#         gamepad=kernel/drivers/hid:gamepad:gamepad/obj
#     )
#     local modargs=( NIH_SOURCE="${KV_OUT_DIR}" )
#
#     dkms_src_compile
# }
# @CODE
#
# Note that due to the inherit order the src_install and pkg_postinst
# phase functions may have to be defined explicitly.
#
# @EXAMPLE:
#
# A more complex example is the case of an ebuild that is currently
# inheriting linux-mod-r1, but is not using any of its phase
# functions. In this case there is usually no modlist for
# dkms_autoconf to convert into a DKMS configuration file.
# Instead the ebuild must utilize a dkms.conf provided by upstream
# in the sources, or alternatively create one from scratch and
# include it in FILESDIR.
#
# Tip: Check if there is a rpm/deb spec or similar script that can
# create a dkms.conf to find a hint of what it should look like and
# where it should be created for this particular package.
#
# @CODE
# inherit dkms linux-mod-r1
#
# src_prepare() {
#   default
#   sed -e "s/@VERSION@/${PV}/" -i modules/dkms.conf || die
# }
#
# src_compile() {
#     if use dkms; then
#         dkms_gentoofy_conf modules/dkms.conf
#     else
#         emake "${MODULES_MAKEARGS[@]}" modules
#     fi
# }
#
# src_install() {
#     if use dkms; then
#         dkms_dopackage modules
#     else
#         linux_domodule modules/mymodule.ko
#         modules_post_process
#     fi
#     einstalldocs
# }
#
# pkg_postinst() {
#     dkms_pkg_postinst
# }
# @CODE

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_DKMS_ECLASS} ]]; then
_DKMS_ECLASS=1

inherit linux-mod-r1

IUSE="dkms"

RDEPEND="dkms? ( sys-kernel/dkms ${BDEPEND} )"
IDEPEND="dkms? ( sys-kernel/dkms ${BDEPEND} )"

# @ECLASS_VARIABLE: DKMS_PACKAGES
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# After dkms_src_install or dkms_dopackage this array will be
# populated with all dkms packages installed by the ebuild. The names
# and versions of each package are separated with a ':'.
DKMS_PACKAGES=()

# @FUNCTION: dkms_gentoofy_conf
# @USAGE: <list of files>
# @DESCRIPTION:
# Adds linux-mod-r1's MODULES_MAKEARGS and the ebuilds modargs to any
# make calls in an existing dkms.conf. This function must be called
# for every dkms.conf that will be installed to ensure that the users
# compiler choice and flags are respected by DKMS at runtime.
# Multiple files may be passed to this function as arguments. If no
# arguments are given than this function runs on the dkms.conf in the
# present working directory. Does nothing if USE=dkms is disabled.
dkms_gentoofy_conf() {
	debug-print-function ${FUNCNAME} "$@"

	use dkms || return 0
	[[ -z ${MODULES_OPTIONAL_IUSE} ]] ||
		use "${MODULES_OPTIONAL_IUSE#+}" || return 0

	local file input=( "${@}" )
	[[ ${#} -eq 0 ]] && input=( dkms.conf )

	# This will set edkmsargs
	dkms_sanitize_makeargs

	for file in "${input[@]}"; do
		[[ -f ${file} ]] ||
			die "${FUNCNAME}: DKMS conf does not exist: ${file}"

		sed -i "${file}" \
			-e "/^MAKE/ s:make :make ${edkmsargs[*]} :" \
			-e "/^MAKE/ s:make$:make ${edkmsargs[*]}:" \
			-e "/^MAKE/ s:make\":make ${edkmsargs[*]}\":" \
			-e "/^MAKE/ s:'make' :'make' ${edkmsargs[*]} : " \
			-e "/^MAKE/ s:'make'$:'make' ${edkmsargs[*]}:" \
			-e "/^MAKE/ s:'make'\":'make' ${edkmsargs[*]}\":" ||
				die "${FUNCNAME}: failed to Gentoo'fy ${file}"
	done
}

# @FUNCTION: dkms_sanitize_makeargs
# @DESCRIPTION:
# Uses linux-mod-r1's MODULES_MAKEARGS and modargs to set the
# edkmsargs array. This array contains all variables from the two
# input arrays except those referencing the current kernel version.
# Quotes are added to the variables to prevent parsing problems at
# DKMS runtime. Does nothing if USE=dkms is disabled.
dkms_sanitize_makeargs() {
	debug-print-function ${FUNCNAME} "$@"

	use dkms || return 0
	[[ -z ${MODULES_OPTIONAL_IUSE} ]] ||
		use "${MODULES_OPTIONAL_IUSE#+}" || return 0

	local -a args=( "${MODULES_MAKEARGS[@]}" )
	[[ ${modargs@a} == *a* ]] && args+=( "${modargs[@]}" )

	edkmsargs=( ${MAKEOPTS} )
	local arg
	for arg in "${args[@]}"; do
		# Replace Gentoo kernel targets with DKMS variables
		case ${arg} in
			*=${KV_OUT_DIR}|*=${KV_DIR})
				edkmsargs+=( "${arg%%=*}=\${kernel_source_dir}" )
			;;
			${KV_OUT_DIR}|${KV_DIR})
				edkmsargs+=( "\${kernel_source_dir}" )
			;;
			*=${KV_FULL})
				edkmsargs+=( "${arg%%=*}=\${kernelver}" )
			;;
			${KV_FULL})
				edkmsargs+=( "\${kernelver}" )
			;;
			*${KV_FULL}*|*${KV_DIR}*|*${KV_OUT_DIR}*)
				# Skip other arguments pointing to the current target
				continue
			;;
			*=*)
				# Quote values for variables to avoid parsing problems
				edkmsargs+=( "${arg%%=*}='${arg#*=}'" )
			;;
			*)
				edkmsargs+=( "${arg}" )
			;;
		esac
	done
}

# @FUNCTION: dkms_autoconf
# @USAGE: [--no-kernelrelease|--no-autoinstall]
# @DESCRIPTION:
# Uses linux-mod-r1's modlist and modargs to construct a DKMS
# configuration file. By default DKMS adds the 'KERNELRELEASE='
# variable to all make commands. Some Makefiles will behave
# differently when this variable is set, if this leads to problems
# pass the --no-kernelrelease argument to this function to suppress
# the addition of 'KERNELRELEASE=' to the calls to make at runtime.
# By default the created DKMS configuration file will enable
# automatic installation of all kernel modules. To disable this add
# the --no-autoinstall argument. Does nothing if USE=dkms is disabled.
dkms_autoconf() {
	debug-print-function ${FUNCNAME} "$@"

	use dkms || return 0
	[[ -z ${MODULES_OPTIONAL_IUSE} ]] ||
		use "${MODULES_OPTIONAL_IUSE#+}" || return 0

	local arg autoinstall=1 make_command=make
	[[ ${#} -gt 2 ]] && die "${FUNCNAME}: too many arguments"
	for arg in "${@}"; do
		case ${arg} in
			--no-kernelrelease)
				# Per DKMS manual, quoting disables setting KERNELRELEASE
				make_command=\'make\'
			;;
			--no-autoinstall)
				autoinstall=
			;;
			*)
				die "${FUNCNAME}: invalid argument ${arg}"
			;;
		esac
	done

	modules_process_modlist

	local index mod name package dkms_config_files=()
	for mod in "${modlist[@]}"; do
		name=${mod%%=*}
		mod=${mod#"${name}"}
		IFS=: read -ra mod <<<"${mod#=}"

		pushd "${mod[1]}" >/dev/null || die
		if [[ -f dkms.conf ]]; then
			# Find the index of an existing module, else find the
			# first available index.
			index=$(
				source dkms.conf &>/dev/null ||
					die "${FUNCNAME}: invalid dkms.conf at ${PWD}"
				for i in "${!BUILT_MODULE_NAME[@]}"; do
					if [[ ${name} == ${BUILT_MODULE_NAME[${i}]} ]]
					then
						echo ${i} || die
						exit 0
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
			EOF
			if [[ -n ${autoinstall} ]]; then
				echo "AUTOINSTALL=yes" >> dkms.conf || die
			else
				echo "AUTOINSTALL=no" >> dkms.conf || die
			fi
			index=0
		fi

		# If there is no MAKE command in this dkms.conf yet, add one
		if ! grep -qE "^MAKE(\[0\]|)=" dkms.conf; then
			echo "MAKE[0]=\"${make_command} ${mod[3]}\"" >> dkms.conf || die
		fi

		# DKMS enforces that the install target starts with one of
		# these options.
		local dest=${mod[0]}
		if ! [[ ${dest} == /kernel* || ${dest} == /updates* ||
			${dest} == /extra* ]]
		then
			dest=/extra/${dest}
		fi

		# Add one empty line in case upstream provided dkms.conf is
		# missing a line ending on the final line. Also looks nicer
		# because now all the settings for each kernel module are
		# grouped together.
		cat <<-EOF >> dkms.conf || die

			BUILT_MODULE_NAME[${index}]=${name}
			BUILT_MODULE_LOCATION[${index}]=.${mod[2]#"${mod[1]%/.}"}/
			DEST_MODULE_NAME[${index}]=${name}
			DEST_MODULE_LOCATION[${index}]=${dest}
		EOF
		if use strip; then
			echo "STRIP[${index}]=yes" >> dkms.conf || die
		else
			echo "STRIP[${index}]=no" >> dkms.conf || die
		fi

		# Append this dkms.conf to our tracker array
		if ! has "${PWD}/dkms.conf" "${dkms_config_files[@]}"; then
			dkms_config_files+=( "${PWD}/dkms.conf" )
		fi
		popd >/dev/null || die
	done

	# Add the users compiler *FLAGS and MAKEOPTS to all dkms.conf's
	dkms_gentoofy_conf "${dkms_config_files[@]}"
}

# @FUNCTION: dkms_dopackage
# @USAGE: <dkms package root>
# @DESCRIPTION:
# Installs a DKMS package to ${ED}/usr/src. If no path is specified
# as the first argument, then the root of the package is assumed to
# be the pwd. Appends the installed package to the global
# DKMS_PACKAGES array. Does nothing if USE=dkms is disabled.
dkms_dopackage() {
	debug-print-function ${FUNCNAME} "$@"

	use dkms || return 0
	[[ -z ${MODULES_OPTIONAL_IUSE} ]] ||
		use "${MODULES_OPTIONAL_IUSE#+}" || return 0

	[[ ${#} -gt 1 ]] && die "${FUNCNAME}: too many arguments"
	local package_root=${1:-"${PWD}"}
	[[ ${package_root} != /* ]] && package_root=${PWD}/${package_root}
	[[ -f ${package_root}/dkms.conf ]] ||
		die "${FUNCNAME}: no DKMS conf at ${package_root}"
	# subshell to avoid polluting the environment with the dkms.conf.
	local package="$(
		source "${package_root}/dkms.conf" &>/dev/null ||
			die "${FUNCNAME}: invalid DKMS conf at ${package_root}"
		dest=/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}
		# Replace references to current dir with merged dir
		sed -i "${package_root}/dkms.conf" \
			-e "s#${package_root}#${EPREFIX}${dest}#g" || die
		mkdir -p "${ED}${dest}" || die
		cp -a "${package_root}"/* "${ED}${dest}" || die
		modules_process_dracut.conf.d "${BUILT_MODULE_NAME[@]}"
		echo "${PACKAGE_NAME}:${PACKAGE_VERSION}"
	)"
	if has "${package}" "${DKMS_PACKAGES[@]}"; then
		die "${FUNCNAME}: DKMS package with the same name is already installed"
	elif [[ ${package} == :* || ${package} == *: ]]; then
		die "${FUNCNAME}: DKMS conf did not set a package name or version"
	else
		DKMS_PACKAGES+=( "${package}" )
	fi
}

# @FUNCTION: dkms_src_compile
# @DESCRIPTION:
# Runs dkms_autoconf if USE=dkms is enabled, otherwise runs
# linux-mod-r1_src_compile. Arguments given to this function are
# passed onto dkms_autoconf.
dkms_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	if ! use dkms; then
		linux-mod-r1_src_compile
		return 0
	fi
	[[ -z ${MODULES_OPTIONAL_IUSE} ]] ||
		use "${MODULES_OPTIONAL_IUSE#+}" || return 0

	dkms_autoconf "${@}"
}

# @FUNCTION: dkms_src_install
# @DESCRIPTION:
# Runs dkms_dopackage for each dkms.conf found in the pwd or any
# sub-directories. Then runs einstalldocs. If USE=dkms is disabled
# then linux-mod-r1_src_install is run instead.
dkms_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	if ! use dkms; then
		linux-mod-r1_src_install
		return 0
	fi
	[[ -z ${MODULES_OPTIONAL_IUSE} ]] ||
		use "${MODULES_OPTIONAL_IUSE#+}" || return 0

	while IFS= read -r -d '' file; do
		dkms_dopackage $(dirname "${file}")
	done < <(find "${PWD}" -type f -name dkms.conf -print0 || die)

	einstalldocs
}

# @FUNCTION: dkms_pkg_config
# @DESCRIPTION:
# Rebuilds and reinstalls all DKMS packages owned by the ebuild.
# Does nothing if USE=dkms is disabled.
dkms_pkg_config() {
	debug-print-function ${FUNCNAME} "$@"

	use dkms || return 0
	[[ -z ${MODULES_OPTIONAL_IUSE} ]] ||
		use "${MODULES_OPTIONAL_IUSE#+}" || return 0

	local package ARCH=$(tc-arch-kernel)
	for package in "${DKMS_PACKAGES[@]}"; do
		IFS=: read -ra package <<<"${package#}"
		[[ ${#package[@]} -eq 2 ]] ||
			die "${FUNCNAME}: incorrect package in ${DKMS_PACKAGES[*]}"
		einfo "Building ${package[0]} version ${package[1]}"
		dkms build -m ${package[0]} -v ${package[1]} --force ||
			die "${FUNCNAME}: failed to build ${package} with DKMS"
		einfo "Installing ${package[0]} version ${package[1]}"
		dkms install -m ${package[0]} -v ${package[1]} --force ||
			die "${FUNCNAME}: failed to install ${package} with DKMS"
	done

	if [[ ${MODULES_INITRAMFS_IUSE} ]] && use dist-kernel &&
		use ${MODULES_INITRAMFS_IUSE#+}
	then
		dist-kernel_reinstall_initramfs "${KV_DIR}" "${KV_FULL}" --all
	fi
}

# @FUNCTION: dkms_postinst
# @DESCRIPTION:
# Registers, builds and installs all DKMS packages owned by the
# ebuild. Calls dist-kernel_reinstall_initramfs if requested by the
# ebuild via linux-mod-r1's MODULES_INITRAMFS_IUSE. Runs
# linux-mod-r1_pkg_postinst if USE=dkms is disabled.
dkms_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"

	if ! use dkms; then
		linux-mod-r1_pkg_postinst
		return 0
	fi
	[[ -z ${MODULES_OPTIONAL_IUSE} ]] ||
		use "${MODULES_OPTIONAL_IUSE#+}" || return 0

	local package ARCH=$(tc-arch-kernel)
	for package in "${DKMS_PACKAGES[@]}"; do
		IFS=: read -ra package <<<"${package#}"
		[[ ${#package[@]} -eq 2 ]] ||
			die "${FUNCNAME}: incorrect package in ${DKMS_PACKAGES[*]}"
		einfo "Registering ${package[0]} version ${package[1]}"
		dkms add -m ${package[0]} -v ${package[1]} ||
			die "${FUNCNAME}: failed to register ${package[0]} with DKMS"
		einfo "Building ${package[0]} version ${package[1]}"
		dkms build -m ${package[0]} -v ${package[1]} \
			-k ${KV_FULL} --force ||
				die "${FUNCNAME}: failed to build ${package[0]} with DKMS"
		einfo "Installing ${package[0]} version ${package[1]}"
		dkms install -m ${package[0]} -v ${package[1]} \
			-k ${KV_FULL} --force ||
				die "${FUNCNAME}: failed to install ${package[0]} with DKMS"
	done

	if [[ ${MODULES_INITRAMFS_IUSE} ]] && use dist-kernel &&
		use ${MODULES_INITRAMFS_IUSE#+}
	then
		dist-kernel_reinstall_initramfs "${KV_DIR}" "${KV_FULL}" --all
	fi
}

# @FUNCTION: dkms_pkg_prerm
# @DESCRIPTION:
# Uninstalls, unbuilds and deregisters all DKMS packages owned by the
# ebuild. Does nothing if USE=dkms is disabled.
dkms_pkg_prerm() {
	debug-print-function ${FUNCNAME} "$@"

	use dkms || return 0
	[[ -z ${MODULES_OPTIONAL_IUSE} ]] ||
		use "${MODULES_OPTIONAL_IUSE#+}" || return 0

	local package ARCH=$(tc-arch-kernel)
	for package in "${DKMS_PACKAGES[@]}"; do
		IFS=: read -ra package <<<"${package#}"
		[[ ${#package[@]} -eq 2 ]] ||
			die "${FUNCNAME}: incorrect package in ${DKMS_PACKAGES[*]}"
		einfo "Uninstalling ${package[0]} version ${package[1]}"
		dkms uninstall -m ${package[0]} -v ${package[1]} --all ||
			ewarn "${FUNCNAME}: failed to uninstall ${package[0]} with DKMS"
		einfo "Unbuilding ${package[0]} version ${package[1]}"
		dkms unbuild -m ${package[0]} -v ${package[1]} --all ||
			ewarn "${FUNCNAME}: failed to unbuild ${package[0]} with DKMS"
		einfo "Deregistering ${package[0]} version ${package[1]}"
		dkms remove -m ${package[0]} -v ${package[1]} --all ||
			ewarn "${FUNCNAME}: failed to deregister ${package[0]} with DKMS"
	done
}

fi

EXPORT_FUNCTIONS src_compile src_install pkg_config pkg_postinst pkg_prerm
