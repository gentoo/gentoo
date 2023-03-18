# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: java-vm-2.eclass
# @MAINTAINER:
# java@gentoo.org
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: Java Virtual Machine eclass
# @DESCRIPTION:
# This eclass provides functionality which assists with installing
# virtual machines, and ensures that they are recognized by java-config.

case ${EAPI} in
	6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_JAVA_VM_2_ECLASS} ]]; then
_JAVA_VM_2_ECLASS=1

inherit multilib pax-utils prefix xdg-utils

RDEPEND="
	dev-java/java-config
	app-eselect/eselect-java
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"
IDEPEND="app-eselect/eselect-java"

if [[ ${EAPI} == 6 ]]; then
	DEPEND+=" ${BDEPEND}"
fi

export WANT_JAVA_CONFIG=2


# @ECLASS_VARIABLE: JAVA_VM_CONFIG_DIR
# @INTERNAL
# @DESCRIPTION:
# Where to place the vm env file.
JAVA_VM_CONFIG_DIR="/usr/share/java-config-2/vm"

# @ECLASS_VARIABLE: JAVA_VM_DIR
# @INTERNAL
# @DESCRIPTION:
# Base directory for vm links.
JAVA_VM_DIR="/usr/lib/jvm"

# @ECLASS_VARIABLE: JAVA_VM_SYSTEM
# @INTERNAL
# @DESCRIPTION:
# Link for system-vm
JAVA_VM_SYSTEM="/etc/java-config-2/current-system-vm"

# @ECLASS_VARIABLE: JAVA_VM_BUILD_ONLY
# @DESCRIPTION:
# Set to YES to mark a vm as build-only.
JAVA_VM_BUILD_ONLY="${JAVA_VM_BUILD_ONLY:-FALSE}"


# @FUNCTION: java-vm-2_pkg_setup
# @DESCRIPTION:
# default pkg_setup
#
# Initialize vm handle.

java-vm-2_pkg_setup() {
	if [[ "${SLOT}" != "0" ]]; then
		VMHANDLE=${PN}-${SLOT}
	else
		VMHANDLE=${PN}
	fi
}


# @FUNCTION: java-vm-2_pkg_postinst
# @DESCRIPTION:
# default pkg_postinst
#
# Set the generation-2 system VM, if it isn't set or the setting is
# invalid. Also update mime database.

java-vm-2_pkg_postinst() {
	if [[ ! -d ${EROOT}${JAVA_VM_SYSTEM} ]]; then
		eselect java-vm set system "${VMHANDLE}"
		einfo "${P} set as the default system-vm."
	fi

	xdg_desktop_database_update
}

# @FUNCTION: has_eselect_java-vm_update
# @INTERNAL
# @DESCRIPTION:
# Checks if an eselect-java version providing "eselect java-vm update"
# is available.
# @RETURN: 0 if >=app-eselect/eselect-java-0.5 is installed, 1 otherwise.
has_eselect_java-vm_update() {
	local has_version_args="-b"
	if [[ ${EAPI} == 6 ]]; then
		has_version_args="--host-root"
	fi

	has_version "${has_version_args}" ">=app-eselect/eselect-java-0.5"
}

# @FUNCTION: java-vm-2_pkg_prerm
# @DESCRIPTION:
# default pkg_prerm
#
# Does nothing if eselect-java-0.5 or newer is available.  Otherwise,
# warn user if removing system-vm.

java-vm-2_pkg_prerm() {
	if has_eselect_java-vm_update; then
		# We will potentially switch to a new Java system VM in
		# pkg_postrm().
		return
	fi

	if [[ $(GENTOO_VM= java-config -f 2>/dev/null) == ${VMHANDLE} && -z ${REPLACED_BY_VERSION} ]]; then
		ewarn "It appears you are removing your system-vm! Please run"
		ewarn "\"eselect java-vm list\" to list available VMs, then use"
		ewarn "\"eselect java-vm set system\" to set a new system-vm!"
	fi
}


# @FUNCTION: java-vm-2_pkg_postrm
# @DESCRIPTION:
# default pkg_postrm
#
# Invoke "eselect java-vm update" if eselect-java 0.5, or newer, is
# available.  Also update the mime database.

java-vm-2_pkg_postrm() {
	xdg_desktop_database_update
	if has_eselect_java-vm_update; then
		eselect java-vm update
	fi
}


# @FUNCTION: get_system_arch
# @DESCRIPTION:
# Get Java specific arch name.
#
# NOTE the mips and sparc values are best guesses. Oracle uses sparcv9
# but does OpenJDK use sparc64? We don't support OpenJDK on sparc or any
# JVM on mips though so it doesn't matter much.

get_system_arch() {
	local abi=${1-${ABI}}

	case $(get_abi_CHOST ${abi}) in
		mips*l*) echo mipsel ;;
		mips*) echo mips ;;
		powerpc64le*) echo ppc64le ;;
		*)
			case ${abi} in
				*_fbsd) get_system_arch ${abi%_fbsd} ;;
				arm64) echo aarch64 ;;
				hppa) echo parisc ;;
				sparc32) echo sparc ;;
				sparc64) echo sparcv9 ;;
				x86*) echo i386 ;;
				*) echo ${abi} ;;
			esac ;;
	esac
}


# @FUNCTION: set_java_env
# @DESCRIPTION:
# Installs a vm env file.
# DEPRECATED, use java-vm_install-env instead.

set_java_env() {
	debug-print-function ${FUNCNAME} $*

	local platform="$(get_system_arch)"
	local env_file="${ED}${JAVA_VM_CONFIG_DIR}/${VMHANDLE}"

	if [[ ${1} ]]; then
		local source_env_file="${1}"
	else
		local source_env_file="${FILESDIR}/${VMHANDLE}.env"
	fi

	if [[ ! -f ${source_env_file} ]]; then
		die "Unable to find the env file: ${source_env_file}"
	fi

	dodir ${JAVA_VM_CONFIG_DIR}
	sed \
		-e "s/@P@/${P}/g" \
		-e "s/@PN@/${PN}/g" \
		-e "s/@PV@/${PV}/g" \
		-e "s/@PF@/${PF}/g" \
		-e "s/@SLOT@/${SLOT}/g" \
		-e "s/@PLATFORM@/${platform}/g" \
		-e "s/@LIBDIR@/$(get_libdir)/g" \
		-e "/^LDPATH=.*lib\\/\\\"/s|\"\\(.*\\)\"|\"\\1${platform}/:\\1${platform}/server/\"|" \
		< "${source_env_file}" \
		> "${env_file}" || die "sed failed"

	(
		echo "VMHANDLE=\"${VMHANDLE}\""
		echo "BUILD_ONLY=\"${JAVA_VM_BUILD_ONLY}\""
	) >> "${env_file}"

	eprefixify ${env_file}

	[[ -n ${JAVA_PROVIDE} ]] && echo "PROVIDES=\"${JAVA_PROVIDE}\"" >> ${env_file}

	local java_home=$(source "${env_file}"; echo ${JAVA_HOME})
	[[ -z ${java_home} ]] && die "No JAVA_HOME defined in ${env_file}"

	# Make the symlink
	dodir "${JAVA_VM_DIR}"
	dosym "${java_home}" "${JAVA_VM_DIR}/${VMHANDLE}"
}


# @FUNCTION: java-vm_install-env
# @DESCRIPTION:
#
# Installs a Java VM environment file. The source can be specified but
# defaults to ${FILESDIR}/${VMHANDLE}.env.sh.
#
# Environment variables within this file will be resolved. You should
# escape the $ when referring to variables that should be resolved later
# such as ${JAVA_HOME}. Subshells may be used but avoid using double
# quotes. See icedtea-bin.env.sh for a good example.

java-vm_install-env() {
	debug-print-function ${FUNCNAME} "$*"

	local env_file="${ED}${JAVA_VM_CONFIG_DIR}/${VMHANDLE}"
	local source_env_file="${1-${FILESDIR}/${VMHANDLE}.env.sh}"

	if [[ ! -f "${source_env_file}" ]]; then
		die "Unable to find the env file: ${source_env_file}"
	fi

	dodir "${JAVA_VM_CONFIG_DIR}"

	# Here be dragons! ;) -- Chewi
	eval echo "\"$(cat <<< "$(sed 's:":\\":g' "${source_env_file}")")\"" > "${env_file}" ||
		die "failed to create Java env file"

	(
		echo "VMHANDLE=\"${VMHANDLE}\""
		echo "BUILD_ONLY=\"${JAVA_VM_BUILD_ONLY}\""
		[[ ${JAVA_PROVIDE} ]] && echo "PROVIDES=\"${JAVA_PROVIDE}\"" || true
	) >> "${env_file}" || die "failed to append to Java env file"

	local java_home=$(unset JAVA_HOME; source "${env_file}"; echo ${JAVA_HOME})
	[[ -z ${java_home} ]] && die "No JAVA_HOME defined in ${env_file}"

	# Make the symlink
	dodir "${JAVA_VM_DIR}"
	dosym "${java_home}" "${JAVA_VM_DIR}/${VMHANDLE}"
}


# @FUNCTION: java-vm_set-pax-markings
# @DESCRIPTION:
# Set PaX markings on all JDK/JRE executables to allow code-generation on
# the heap by the JIT compiler.
#
# The markings need to be set prior to the first invocation of the the freshly
# built / installed VM. Be it before creating the Class Data Sharing archive or
# generating cacerts. Otherwise a PaX enabled kernel will kill the VM.
# Bug #215225 #389751
#
# @CODE
#   Parameters:
#     $1 - JDK/JRE base directory.
#
#   Examples:
#     java-vm_set-pax-markings "${S}"
#     java-vm_set-pax-markings "${ED}"/opt/${P}
# @CODE

java-vm_set-pax-markings() {
	debug-print-function ${FUNCNAME} "$*"
	[[ $# -ne 1 ]] && die "${FUNCNAME}: takes exactly one argument"
	[[ ! -f "${1}"/bin/java ]] \
		&& die "${FUNCNAME}: argument needs to be JDK/JRE base directory"

	local executables=( "${1}"/bin/* )
	[[ -d "${1}"/jre ]] && executables+=( "${1}"/jre/bin/* )

	# Usually disabling MPROTECT is sufficient.
	local pax_markings="m"
	# On x86 for heap sizes over 700MB disable SEGMEXEC and PAGEEXEC as well.
	use x86 && pax_markings+="sp"

	pax-mark ${pax_markings} $(list-paxables "${executables[@]}")
}


# @FUNCTION: java-vm_revdep-mask
# @DESCRIPTION:
# Installs a revdep-rebuild control file which SEARCH_DIR_MASK set to the path
# where the VM is installed. Prevents pointless rebuilds - see bug #177925.
# Also gives a notice to the user.
#
# @CODE
#   Parameters:
#     $1 - Path of the VM (defaults to /opt/${P} if not set)
#
#   Examples:
#     java-vm_revdep-mask
#     java-vm_revdep-mask /path/to/jdk/
#
# @CODE

java-vm_revdep-mask() {
	debug-print-function ${FUNCNAME} "$*"

	local VMROOT="${1-"${EPREFIX}"/opt/${P}}"

	dodir /etc/revdep-rebuild
	echo "SEARCH_DIRS_MASK=\"${VMROOT}\"" >> "${ED}/etc/revdep-rebuild/61-${VMHANDLE}" \
		 || die "Failed to write revdep-rebuild mask file"
}


# @FUNCTION: java-vm_sandbox-predict
# @DESCRIPTION:
# Install a sandbox control file. Specified paths won't cause a sandbox
# violation if opened read write but no write takes place. See bug 388937#c1
#
# @CODE
#   Examples:
#     java-vm_sandbox-predict /dev/random /proc/self/coredump_filter
# @CODE

java-vm_sandbox-predict() {
	debug-print-function ${FUNCNAME} "$*"
	[[ -z "${1}" ]] && die "${FUNCNAME} takes at least one argument"

	local path path_arr=("$@")
	# subshell this to prevent IFS bleeding out dependant on bash version.
	# could use local, which *should* work, but that requires a lot of testing.
	path=$(IFS=":"; echo "${path_arr[*]}")
	dodir /etc/sandbox.d
	echo "SANDBOX_PREDICT=\"${path}\"" > "${ED}/etc/sandbox.d/20${VMHANDLE}" \
		|| die "Failed to write sandbox control file"
}

fi

EXPORT_FUNCTIONS pkg_setup pkg_postinst pkg_prerm pkg_postrm
