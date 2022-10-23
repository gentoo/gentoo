# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: linux-mod.eclass
# @MAINTAINER:
# kernel@gentoo.org
# @AUTHOR:
# John Mylchreest <johnm@gentoo.org>,
# Stefan Schweizer <genstef@gentoo.org>
# @SUPPORTED_EAPIS: 6 7 8
# @PROVIDES: linux-info
# @BLURB: It provides the functionality required to install external modules against a kernel source tree.
# @DESCRIPTION:
# This eclass is used to interface with linux-info.eclass in such a way
# to provide the functionality and initial functions
# required to install external modules against a kernel source
# tree.

# A Couple of env vars are available to effect usage of this eclass
# These are as follows:

# @ECLASS_VARIABLE: MODULES_OPTIONAL_USE
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# A string containing the USE flag to use for making this eclass optional
# The recommended non-empty value is 'modules'

# @ECLASS_VARIABLE: MODULES_OPTIONAL_USE_IUSE_DEFAULT
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# A boolean to control the IUSE default state for the MODULES_OPTIONAL_USE USE
# flag. Default value is unset (false). True represented by 1 or 'on', other
# values including unset treated as false.

# @ECLASS_VARIABLE: KERNEL_DIR
# @DESCRIPTION:
# A string containing the directory of the target kernel sources. The default value is
# "/usr/src/linux"
: ${KERNEL_DIR:=/usr/src/linux}

# @ECLASS_VARIABLE: ECONF_PARAMS
# @DEFAULT_UNSET
# @DESCRIPTION:
# It's a string containing the parameters to pass to econf.
# If this is not set, then econf isn't run.

# @ECLASS_VARIABLE: BUILD_PARAMS
# @DEFAULT_UNSET
# @DESCRIPTION:
# It's a string with the parameters to pass to emake.

# @ECLASS_VARIABLE: BUILD_TARGETS
# @DESCRIPTION:
# It's a string with the build targets to pass to make. The default value is "clean module"
: ${BUILD_TARGETS:=clean module}

# @ECLASS_VARIABLE: MODULE_NAMES
# @DEFAULT_UNSET
# @DESCRIPTION:
# It's a string containing the modules to be built automatically using the default
# src_compile/src_install. It will only make ${BUILD_TARGETS} once in any directory.
#
# The structure of each MODULE_NAMES entry is as follows:
#
#   modulename(libdir:srcdir:objdir)
#
# where:
#
#   modulename = name of the module file excluding the .ko
#   libdir     = place in system modules directory where module is installed (by default it's misc)
#   srcdir     = place for ebuild to cd to before running make (by default it's ${S})
#   objdir     = place the .ko and objects are located after make runs (by default it's set to srcdir)
#
# To get an idea of how these variables are used, here's a few lines
# of code from around line 540 in this eclass:
#
#	einfo "Installing ${modulename} module"
#	cd ${objdir} || die "${objdir} does not exist"
#	insinto /lib/modules/${KV_FULL}/${libdir}
#	doins ${modulename}.${KV_OBJ} || die "doins ${modulename}.${KV_OBJ} failed"
#
# For example:
#   MODULE_NAMES="module_pci(pci:${S}/pci:${S}) module_usb(usb:${S}/usb:${S})"
#
# what this would do is
#
#   cd "${S}"/pci
#   make ${BUILD_PARAMS} ${BUILD_TARGETS}
#   cd "${S}"
#   insinto /lib/modules/${KV_FULL}/pci
#   doins module_pci.${KV_OBJ}
#
#   cd "${S}"/usb
#   make ${BUILD_PARAMS} ${BUILD_TARGETS}
#   cd "${S}"
#   insinto /lib/modules/${KV_FULL}/usb
#   doins module_usb.${KV_OBJ}

# There is also support for automated modprobe.d file generation.
# This can be explicitly enabled by setting any of the following variables.

# @ECLASS_VARIABLE: MODULESD_<modulename>_ENABLED
# @DEFAULT_UNSET
# @DESCRIPTION:
# This is used to disable the modprobe.d file generation otherwise the file will be
# always generated (unless no MODULESD_<modulename>_* variable is provided). Set to "no" to disable
# the generation of the file and the installation of the documentation.

# @ECLASS_VARIABLE: MODULESD_<modulename>_EXAMPLES
# @DEFAULT_UNSET
# @DESCRIPTION:
# This is a bash array containing a list of examples which should
# be used. If you want us to try and take a guess set this to "guess".
#
# For each array_component it's added an options line in the modprobe.d file
#
#   options array_component
#
# where array_component is "<modulename> options" (see modprobe.conf(5))

# @ECLASS_VARIABLE: MODULESD_<modulename>_ALIASES
# @DEFAULT_UNSET
# @DESCRIPTION:
# This is a bash array containing a list of associated aliases.
#
# For each array_component it's added an alias line in the modprobe.d file
#
#   alias array_component
#
# where array_component is "wildcard <modulename>" (see modprobe.conf(5))

# @ECLASS_VARIABLE: MODULESD_<modulename>_ADDITIONS
# @DEFAULT_UNSET
# @DESCRIPTION:
# This is a bash array containing a list of additional things to
# add to the bottom of the file. This can be absolutely anything.
# Each entry is a new line.

# @ECLASS_VARIABLE: MODULESD_<modulename>_DOCS
# @DEFAULT_UNSET
# @DESCRIPTION:
# This is a string list which contains the full path to any associated
# documents for <modulename>. These files are installed in the live tree.

# @ECLASS_VARIABLE: KV_OBJ
# @INTERNAL
# @DESCRIPTION:
# It's a read-only variable. It contains the extension of the kernel modules.

case ${EAPI:-0} in
	[67])
		inherit eutils
		;;
	8)
		;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_LINUX_MOD_ECLASS} ]] ; then
_LINUX_MOD_ECLASS=1

# TODO: When adding support for future EAPIs, please audit this list
# for unused inherits and conditionalise them.
inherit linux-info multilib multiprocessing toolchain-funcs

case ${MODULES_OPTIONAL_USE_IUSE_DEFAULT:-n} in
  [nNfF]*|[oO][fF]*|0|-) _modules_optional_use_iuse_default='' ;;
  *) _modules_optional_use_iuse_default='+' ;;
esac

[[ -n "${_modules_optional_use_iuse_default}" ]] && case ${EAPI:-0} in
	0) die "EAPI=${EAPI} is not supported with MODULES_OPTIONAL_USE_IUSE_DEFAULT due to lack of IUSE defaults" ;;
esac

IUSE="dist-kernel
	${MODULES_OPTIONAL_USE:+${_modules_optional_use_iuse_default}}${MODULES_OPTIONAL_USE}"
SLOT="0"
RDEPEND="
	${MODULES_OPTIONAL_USE}${MODULES_OPTIONAL_USE:+? (}
		kernel_linux? (
			sys-apps/kmod[tools]
			dist-kernel? ( virtual/dist-kernel:= )
		)
	${MODULES_OPTIONAL_USE:+)}"
DEPEND="${RDEPEND}
    ${MODULES_OPTIONAL_USE}${MODULES_OPTIONAL_USE:+? (}
	sys-apps/sed
	kernel_linux? ( virtual/linux-sources virtual/libelf )
	${MODULES_OPTIONAL_USE:+)}"

# eclass utilities
# ----------------------------------

# @FUNCTION: use_m
# @RETURN: true or false
# @DESCRIPTION:
# It checks if the kernel version is greater than 2.6.5.
use_m() {
	debug-print-function ${FUNCNAME} $*

	# if we haven't determined the version yet, we need too.
	get_version;

	# if the kernel version is greater than 2.6.6 then we should use
	# M= instead of SUBDIRS=
	[ ${KV_MAJOR} -ge 3 ] && return 0
	[ ${KV_MAJOR} -eq 2 -a ${KV_MINOR} -gt 5 -a ${KV_PATCH} -gt 5 ] && \
		return 0 || return 1
}

# @FUNCTION: convert_to_m
# @USAGE: </path/to/the/file>
# @DESCRIPTION:
# It converts a file (e.g. a makefile) to use M= instead of SUBDIRS=
convert_to_m() {
	debug-print-function ${FUNCNAME} $*

	if use_m
	then
		[ ! -f "${1}" ] && \
			die "convert_to_m() requires a filename as an argument"
		ebegin "Converting ${1/${WORKDIR}\//} to use M= instead of SUBDIRS="
		sed -i 's:SUBDIRS=:M=:g' "${1}"
		eend $?
	fi
}

# @FUNCTION: update_depmod
# @INTERNAL
# @DESCRIPTION:
# Updates the modules.dep file for the current kernel.
update_depmod() {
	debug-print-function ${FUNCNAME} $*

	# if we haven't determined the version yet, we need too.
	get_version;

	ebegin "Updating module dependencies for ${KV_FULL}"
	if [ -r "${KV_OUT_DIR}"/System.map ]
	then
		depmod -ae -F "${KV_OUT_DIR}"/System.map -b "${ROOT:-/}" ${KV_FULL}
		eend $?
	else
		ewarn
		ewarn "${KV_OUT_DIR}/System.map not found."
		ewarn "You must manually update the kernel module dependencies using depmod."
		eend 1
		ewarn
	fi
}

# @FUNCTION: move_old_moduledb
# @INTERNAL
# @DESCRIPTION:
# Updates the location of the database used by the module-rebuild utility.
move_old_moduledb() {
	debug-print-function ${FUNCNAME} $*

	local OLDDIR="${ROOT%/}"/usr/share/module-rebuild
	local NEWDIR="${ROOT%/}"/var/lib/module-rebuild

	if [[ -f "${OLDDIR}"/moduledb ]]; then
		[[ ! -d "${NEWDIR}" ]] && mkdir -p "${NEWDIR}"
		[[ ! -f "${NEWDIR}"/moduledb ]] && \
			mv "${OLDDIR}"/moduledb "${NEWDIR}"/moduledb
		rm -f "${OLDDIR}"/*
		rmdir "${OLDDIR}"
	fi
}

# @FUNCTION: update_moduledb
# @DESCRIPTION:
# Adds the package to the /var/lib/module-rebuild/moduledb database used by the module-rebuild utility.
update_moduledb() {
	debug-print-function ${FUNCNAME} $*

	local MODULEDB_DIR="${ROOT%/}"/var/lib/module-rebuild
	move_old_moduledb

	if [[ ! -f "${MODULEDB_DIR}"/moduledb ]]; then
		[[ ! -d "${MODULEDB_DIR}" ]] && mkdir -p "${MODULEDB_DIR}"
		touch "${MODULEDB_DIR}"/moduledb
	fi

	if ! grep -qs ${CATEGORY}/${PN}-${PVR} "${MODULEDB_DIR}"/moduledb ; then
		einfo "Adding module to moduledb."
		echo "a:1:${CATEGORY}/${PN}-${PVR}" >> "${MODULEDB_DIR}"/moduledb
	fi
}

# @FUNCTION: remove_moduledb
# @DESCRIPTION:
# Removes the package from the /var/lib/module-rebuild/moduledb database used by
remove_moduledb() {
	debug-print-function ${FUNCNAME} $*

	local MODULEDB_DIR="${ROOT%/}"/var/lib/module-rebuild
	move_old_moduledb

	if grep -qs ${CATEGORY}/${PN}-${PVR} "${MODULEDB_DIR}"/moduledb ; then
		einfo "Removing ${CATEGORY}/${PN}-${PVR} from moduledb."
		sed -i -e "/.*${CATEGORY}\/${PN}-${PVR}.*/d" "${MODULEDB_DIR}"/moduledb
	fi
}

# @FUNCTION: set_kvobj
# @DESCRIPTION:
# It sets the KV_OBJ variable.
set_kvobj() {
	debug-print-function ${FUNCNAME} $*

	if kernel_is ge 2 6
	then
		KV_OBJ="ko"
	else
		KV_OBJ="o"
	fi
	# Do we really need to know this?
	# Lets silence it.
	# einfo "Using KV_OBJ=${KV_OBJ}"
}

# @FUNCTION: get-KERNEL_CC
# @RETURN: Name of the C compiler.
# @DESCRIPTION:
# Return name of the C compiler while honoring variables defined in ebuilds.
get-KERNEL_CC() {
	debug-print-function ${FUNCNAME} $*

	if [[ -n ${KERNEL_CC} ]] ; then
		echo "${KERNEL_CC}"
		return
	fi

	local kernel_cc
	if [ -n "${KERNEL_ABI}" ]; then
		# In future, an arch might want to define CC_$ABI
		#kernel_cc="$(get_abi_CC)"
		#[ -z "${kernel_cc}" ] &&
		kernel_cc="$(tc-getCC $(ABI=${KERNEL_ABI} get_abi_CHOST))"
	else
		kernel_cc=$(tc-getCC)
	fi
	echo "${kernel_cc}"
}

# @FUNCTION: generate_modulesd
# @INTERNAL
# @USAGE: /path/to/the/modulename_without_extension
# @RETURN: A file in /etc/modprobe.d
# @DESCRIPTION:
# This function will generate and install the neccessary modprobe.d file from the
# information contained in the modules exported parms.
# (see the variables MODULESD_<modulename>_ENABLED, MODULESD_<modulename>_EXAMPLES,
# MODULESD_<modulename>_ALIASES, MODULESD_<modulename>_ADDITION and MODULESD_<modulename>_DOCS).
#
# At the end the documentation specified with MODULESD_<modulename>_DOCS is installed.
generate_modulesd() {
	debug-print-function ${FUNCNAME} $*
	[ -n "${MODULES_OPTIONAL_USE}" ] && use !${MODULES_OPTIONAL_USE} && return

	local currm_path currm currm_t t myIFS myVAR
	local module_docs module_enabled module_aliases \
			module_additions module_examples module_modinfo module_opts

	for currm_path in ${@}
	do
		currm=${currm_path//*\/}
		currm=$(echo ${currm} | tr '[:lower:]' '[:upper:]')
		currm_t=${currm}
		while [[ -z ${currm_t//*-*} ]]; do
			currm_t=${currm_t/-/_}
		done

		module_docs="$(eval echo \${MODULESD_${currm_t}_DOCS})"
		module_enabled="$(eval echo \${MODULESD_${currm_t}_ENABLED})"
		module_aliases="$(eval echo \${#MODULESD_${currm_t}_ALIASES[*]})"
		module_additions="$(eval echo \${#MODULESD_${currm_t}_ADDITIONS[*]})"
		module_examples="$(eval echo \${#MODULESD_${currm_t}_EXAMPLES[*]})"

		[[ ${module_aliases} -eq 0 ]]	&& unset module_aliases
		[[ ${module_additions} -eq 0 ]]	&& unset module_additions
		[[ ${module_examples} -eq 0 ]]  && unset module_examples

		# If we specify we dont want it, then lets exit, otherwise we assume
		# that if its set, we do want it.
		[[ ${module_enabled} == no ]] && return 0

		# unset any unwanted variables.
		for t in ${!module_*}
		do
			[[ -z ${!t} ]] && unset ${t}
		done

		[[ -z ${!module_*} ]] && return 0

		# OK so now if we have got this far, then we know we want to continue
		# and generate the modprobe.d file.
		module_modinfo="$(modinfo -p ${currm_path}.${KV_OBJ})"
		module_config="${T}/modulesd-${currm}"

		ebegin "Preparing file for modprobe.d"
		#-----------------------------------------------------------------------
		echo "# modprobe.d configuration file for ${currm}" >> "${module_config}"
		#-----------------------------------------------------------------------
		[[ -n ${module_docs} ]] && \
			echo "# For more information please read:" >> "${module_config}"
		for t in ${module_docs}
		do
			echo "#    ${t//*\/}" >> "${module_config}"
		done
		echo >> "${module_config}"

		#-----------------------------------------------------------------------
		if [[ ${module_aliases} -gt 0 ]]
		then
			echo  "# Internal Aliases - Do not edit" >> "${module_config}"
			echo  "# ------------------------------" >> "${module_config}"

			for((t=0; t<${module_aliases}; t++))
			do
				echo "alias $(eval echo \${MODULESD_${currm}_ALIASES[$t]})" \
					>> "${module_config}"
			done
			echo '' >> "${module_config}"
		fi

		#-----------------------------------------------------------------------
		if [[ -n ${module_modinfo} ]]
		then
			echo >> "${module_config}"
			echo  "# Configurable module parameters" >> "${module_config}"
			echo  "# ------------------------------" >> "${module_config}"
			myIFS="${IFS}"
			IFS="$(echo -en "\n\b")"

			for t in ${module_modinfo}
			do
				myVAR="$(echo ${t#*:}  | grep -o "[^ ]*[0-9][ =][^ ]*" | tail -1  | grep -o "[0-9]")"
				if [[ -n ${myVAR} ]]
				then
					module_opts="${module_opts} ${t%%:*}:${myVAR}"
				fi
				echo -e "# ${t%%:*}:\t${t#*:}" >> "${module_config}"
			done
			IFS="${myIFS}"
			echo '' >> "${module_config}"
		fi

		#-----------------------------------------------------------------------
		if [[ $(eval echo \${MODULESD_${currm}_ALIASES[0]}) == guess ]]
		then
			# So lets do some guesswork eh?
			if [[ -n ${module_opts} ]]
			then
				echo "# For Example..." >> "${module_config}"
				echo "# --------------" >> "${module_config}"
				for t in ${module_opts}
				do
					echo "# options ${currm} ${t//:*}=${t//*:}" >> "${module_config}"
				done
				echo '' >> "${module_config}"
			fi
		elif [[ ${module_examples} -gt 0 ]]
		then
			echo "# For Example..." >> "${module_config}"
			echo "# --------------" >> "${module_config}"
			for((t=0; t<${module_examples}; t++))
			do
				echo "options $(eval echo \${MODULESD_${currm}_EXAMPLES[$t]})" \
					>> "${module_config}"
			done
			echo '' >> "${module_config}"
		fi

		#-----------------------------------------------------------------------
		if [[ ${module_additions} -gt 0 ]]
		then
			for((t=0; t<${module_additions}; t++))
			do
				echo "$(eval echo \${MODULESD_${currm}_ADDITIONS[$t]})" \
					>> "${module_config}"
			done
			echo '' >> "${module_config}"
		fi

		#-----------------------------------------------------------------------

		# then we install it
		insinto /etc/modprobe.d
		newins "${module_config}" "${currm_path//*\/}.conf"

		# and install any documentation we might have.
		[[ -n ${module_docs} ]] && dodoc ${module_docs}
	done
	eend 0
	return 0
}

# @FUNCTION: find_module_params
# @USAGE: A string "NAME(LIBDIR:SRCDIR:OBJDIR)"
# @INTERNAL
# @RETURN: The string "modulename:NAME libdir:LIBDIR srcdir:SRCDIR objdir:OBJDIR"
# @DESCRIPTION:
# Analyze the specification NAME(LIBDIR:SRCDIR:OBJDIR) of one module as described in MODULE_NAMES.
find_module_params() {
	debug-print-function ${FUNCNAME} $*

	local matched_offset=0 matched_opts=0 test="${@}" temp_var result
	local i=0 y=0 z=0

	for((i=0; i<=${#test}; i++))
	do
		case ${test:${i}:1} in
			\()		matched_offset[0]=${i};;
			\:)		matched_opts=$((${matched_opts} + 1));
					matched_offset[${matched_opts}]="${i}";;
			\))		matched_opts=$((${matched_opts} + 1));
					matched_offset[${matched_opts}]="${i}";;
		esac
	done

	for((i=0; i<=${matched_opts}; i++))
	do
		# i			= offset were working on
		# y			= last offset
		# z			= current offset - last offset
		# temp_var	= temporary name
		case ${i} in
			0)	tempvar=${test:0:${matched_offset[0]}};;
			*)	y=$((${matched_offset[$((${i} - 1))]} + 1))
				z=$((${matched_offset[${i}]} - ${matched_offset[$((${i} - 1))]}));
				z=$((${z} - 1))
				tempvar=${test:${y}:${z}};;
		esac

		case ${i} in
			0)	result="${result} modulename:${tempvar}";;
			1)	result="${result} libdir:${tempvar}";;
			2)	result="${result} srcdir:${tempvar}";;
			3)	result="${result} objdir:${tempvar}";;
		esac
	done

	echo ${result}
}

# default ebuild functions
# --------------------------------

# @FUNCTION: linux-mod_pkg_setup
# @DESCRIPTION:
# It checks the CONFIG_CHECK options (see linux-info.eclass(5)), verifies that the kernel is
# configured, verifies that the sources are prepared, verifies that the modules support is builtin
# in the kernel and sets the object extension KV_OBJ.
linux-mod_pkg_setup() {
	debug-print-function ${FUNCNAME} $*
	[ -n "${MODULES_OPTIONAL_USE}" ] && use !${MODULES_OPTIONAL_USE} && return

	local is_bin="${MERGE_TYPE}"

	# If we are installing a binpkg, take a different path.
	if [[ ${is_bin} == binary ]]; then
		linux-mod_pkg_setup_binary
		return
	fi

	# External modules use kernel symbols (bug #591832)
	CONFIG_CHECK+=" !TRIM_UNUSED_KSYMS"

	linux-info_pkg_setup;
	require_configured_kernel
	check_kernel_built;
	strip_modulenames;
	[[ -n ${MODULE_NAMES} ]] && check_modules_supported
	set_kvobj;
}

# @FUNCTION: linux-mod_pkg_setup_binary
# @DESCRIPTION:
# Perform all kernel option checks non-fatally, as the .config and
# /proc/config.gz might not be present. Do not do anything that requires kernel
# sources.
linux-mod_pkg_setup_binary() {
	debug-print-function ${FUNCNAME} $*
	local new_CONFIG_CHECK
	# ~ needs always to be quoted, else bash expands it.
	for config in $CONFIG_CHECK ; do
		optional='~'
		[[ ${config:0:1} == "~" ]] && optional=''
		new_CONFIG_CHECK="${new_CONFIG_CHECK} ${optional}${config}"
	done
	CONFIG_CHECK="${new_CONFIG_CHECK}"
	linux-info_pkg_setup;
}

# @FUNCTION: strip_modulenames
# @DESCRIPTION:
# Remove modules from being built automatically using the default src_compile/src_install
strip_modulenames() {
	debug-print-function ${FUNCNAME} $*

	local i
	for i in ${MODULE_IGNORE}; do
		MODULE_NAMES=${MODULE_NAMES//${i}(*}
	done
}

# @FUNCTION: linux-mod_src_compile
# @DESCRIPTION:
# It compiles all the modules specified in MODULE_NAMES. For each module the econf command is
# executed only if ECONF_PARAMS is defined, the name of the target is specified by BUILD_TARGETS
# while the options are in BUILD_PARAMS (all the modules share these variables). The compilation
# happens inside ${srcdir}.
#
# Look at the description of these variables for more details.
linux-mod_src_compile() {
	debug-print-function ${FUNCNAME} $*
	[ -n "${MODULES_OPTIONAL_USE}" ] && use !${MODULES_OPTIONAL_USE} && return

	local modulename libdir srcdir objdir i n myABI="${ABI}"
	set_arch_to_kernel
	ABI="${KERNEL_ABI}"

	[[ -n ${KERNEL_DIR} ]] && addpredict "${KERNEL_DIR}/null.dwo"

	# Set CROSS_COMPILE in the environment.
	# This allows it to be overridden in local Makefiles.
	# https://bugs.gentoo.org/550428
	local -x CROSS_COMPILE=${CROSS_COMPILE-${CHOST}-}

	BUILD_TARGETS=${BUILD_TARGETS:-clean module}
	strip_modulenames;
	cd "${S}"
	touch Module.symvers
	for i in ${MODULE_NAMES}
	do
		unset libdir srcdir objdir
		for n in $(find_module_params ${i})
		do
			eval ${n/:*}=${n/*:/}
		done
		libdir=${libdir:-misc}
		srcdir=${srcdir:-${S}}
		objdir=${objdir:-${srcdir}}

		if [ ! -f "${srcdir}/.built" ];
		then
			cd "${srcdir}"
			ln -s "${S}"/Module.symvers Module.symvers
			einfo "Preparing ${modulename} module"
			if [[ -n ${ECONF_PARAMS} ]]
			then
				econf ${ECONF_PARAMS} || \
				die "Unable to run econf ${ECONF_PARAMS}"
			fi

			# This looks messy, but it is needed to handle multiple variables
			# being passed in the BUILD_* stuff where the variables also have
			# spaces that must be preserved. If don't do this, then the stuff
			# inside the variables gets used as targets for Make, which then
			# fails.
			eval "emake HOSTCC=\"$(tc-getBUILD_CC)\" \
						LDFLAGS=\"$(get_abi_LDFLAGS)\" \
						${BUILD_FIXES} \
						${BUILD_PARAMS} \
						${BUILD_TARGETS} " \
				|| die "Unable to emake HOSTCC="$(tc-getBUILD_CC)" LDFLAGS="$(get_abi_LDFLAGS)" ${BUILD_FIXES} ${BUILD_PARAMS} ${BUILD_TARGETS}"
			cd "${OLDPWD}"
			touch "${srcdir}"/.built
		fi
	done

	set_arch_to_pkgmgr
	ABI="${myABI}"
}

# @FUNCTION: linux-mod_src_install
# @DESCRIPTION:
# It install the modules specified in MODULE_NAMES. The modules should be inside the ${objdir}
# directory and they are installed inside /lib/modules/${KV_FULL}/${libdir}.
#
# The modprobe.d configuration file is automatically generated if the
# MODULESD_<modulename>_* variables are defined. The only way to stop this process is by
# setting MODULESD_<modulename>_ENABLED=no. At the end the documentation specified via
# MODULESD_<modulename>_DOCS is also installed.
#
# Look at the description of these variables for more details.
linux-mod_src_install() {
	debug-print-function ${FUNCNAME} $*
	[ -n "${MODULES_OPTIONAL_USE}" ] && use !${MODULES_OPTIONAL_USE} && return

	local modulename libdir srcdir objdir i n

	[[ -n ${KERNEL_DIR} ]] && addpredict "${KERNEL_DIR}/null.dwo"

	strip_modulenames;
	for i in ${MODULE_NAMES}
	do
		unset libdir srcdir objdir
		for n in $(find_module_params ${i})
		do
			eval ${n/:*}=${n/*:/}
		done
		libdir=${libdir:-misc}
		srcdir=${srcdir:-${S}}
		objdir=${objdir:-${srcdir}}

		einfo "Installing ${modulename} module"
		cd "${objdir}" || die "${objdir} does not exist"
		insinto "${INSTALL_MOD_PATH}"/lib/modules/${KV_FULL}/${libdir}

		# check here for CONFIG_MODULE_COMPRESS_<compression option> (NONE, GZIP, XZ, ZSTD)
		# and similarily compress the module being built if != NONE.

		if linux_chkconfig_present MODULE_COMPRESS_XZ; then
			xz -T$(makeopts_jobs) --memlimit-compress=50% -q ${modulename}.${KV_OBJ} || die "Compressing ${modulename}.${KV_OBJ} with xz failed"
			doins ${modulename}.${KV_OBJ}.xz
		elif linux_chkconfig_present MODULE_COMPRESS_GZIP; then
			if type -P pigz &>/dev/null ; then
				pigz -p$(makeopts_jobs) ${modulename}.${KV_OBJ} || die "Compressing ${modulename}.${KV_OBJ} with pigz failed"
			else
				gzip ${modulename}.${KV_OBJ} || die "Compressing ${modulename}.${KV_OBJ} with gzip failed"
			fi
			doins ${modulename}.${KV_OBJ}.gz
		elif linux_chkconfig_present MODULE_COMPRESS_ZSTD; then
			zstd -T$(makeopts_jobs) ${modulename}.${KV_OBJ} || "Compressing ${modulename}.${KV_OBJ} with zstd failed"
			doins ${modulename}.${KV_OBJ}.zst
		else
			doins ${modulename}.${KV_OBJ}
		fi
		cd "${OLDPWD}" || die "${OLDPWD} does not exist"

		generate_modulesd "${objdir}/${modulename}"
	done
}

# @FUNCTION: linux-mod_pkg_preinst
# @DESCRIPTION:
# It checks what to do after having merged the package.
linux-mod_pkg_preinst() {
	debug-print-function ${FUNCNAME} $*
	[ -n "${MODULES_OPTIONAL_USE}" ] && use !${MODULES_OPTIONAL_USE} && return

	[ -d "${D%/}/lib/modules" ] && UPDATE_DEPMOD=true || UPDATE_DEPMOD=false
	[ -d "${D%/}/lib/modules" ] && UPDATE_MODULEDB=true || UPDATE_MODULEDB=false
}

# @FUNCTION: linux-mod_pkg_postinst
# @DESCRIPTION:
# It executes /sbin/depmod and adds the package to the /var/lib/module-rebuild/moduledb
# database (if ${D}/lib/modules is created)"
linux-mod_pkg_postinst() {
	debug-print-function ${FUNCNAME} $*
	[ -n "${MODULES_OPTIONAL_USE}" ] && use !${MODULES_OPTIONAL_USE} && return

	${UPDATE_DEPMOD} && update_depmod;
	${UPDATE_MODULEDB} && update_moduledb;
}

# @FUNCTION: linux-mod_pkg_postrm
# @DESCRIPTION:
# It removes the package from the /var/lib/module-rebuild/moduledb database but it doens't
# call /sbin/depmod because the modules are still installed.
linux-mod_pkg_postrm() {
	debug-print-function ${FUNCNAME} $*
	[ -n "${MODULES_OPTIONAL_USE}" ] && use !${MODULES_OPTIONAL_USE} && return
	remove_moduledb;
}

fi

EXPORT_FUNCTIONS pkg_setup src_compile src_install \
	pkg_preinst pkg_postinst pkg_postrm
