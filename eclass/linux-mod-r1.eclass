# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: linux-mod-r1.eclass
# @MAINTAINER:
# Ionen Wolkens <ionen@gentoo.org>
# Gentoo Kernel project <kernel@gentoo.org>
# @AUTHOR:
# Ionen Wolkens <ionen@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @PROVIDES: linux-info
# @BLURB: Functions for installing out-of-tree Linux kernel modules
# @DESCRIPTION:
# See the linux-mod-r1_src_compile function documentation for in-depth
# usage, and see the example further down for a quick overview.
#
# @SUBSECTION linux-mod -> linux-mod-r1 migration notes
#  0. Define a src_compile if missing, local variables below go there.
#  1. MODULE_NAMES="name(libdir:srcdir:objdir)"
#     BUILD_TARGETS="target"
#       -> local modlist=( name=libdir:srcdir:objdir:target(s) )
#     - try without :target first, it is now almost always unnecessary
#     - srcdir defaults to the current directory, and note that paths
#       can be relative to that (should typically *not* pass ${S})
#  2. BUILD_PARAMS and/or BUILD_FIXES
#       -> local modargs=( VAR="${KV_OUT_DIR}" ... )
#     - CC/LD and similar are unneeded, always passed (V=1 too)
#     - eval (aka eval "${BUILD_PARAMS}") is /not/ used for this anymore
#  3. s/linux-mod_/linux-mod-r1/g
#  4. _preinst+_postrm can be dropped, keep linux-mod-r1_pkg_postinst
#  5. linux-mod-r1_src_install now runs einstalldocs, adjust as needed
#  6. if *not* using linux-mod-r1_src_compile/install, then refer to
#     the eclass' 2nd example and ensure using modules_post_process
#  7. If any, clang<->gcc switching custom workarounds can be dropped
#  8. See MODULES_KERNEL_MAX/_MIN if had or need kernel version checks.
#
# Not an exhaustive list, verify that no installed files are missing
# after.  Look for "command not found" errors in the build log too.
#
# Revision bumps are not strictly needed to migrate unless want to
# keep the old as fallback for regressions, kernel upgrades or the
# new IUSE=+strip will typically cause rebuilds either way.
#
# @EXAMPLE:
#
# If source directory S had a layout such as:
#  - Makefile (builds a gentoo.ko in current directory)
#  - gamepad/Makefile (want to install to kernel/drivers/hid)
#  - gamepad/obj/ (the built gamepad.ko ends up here)
#
# ...and the Makefile uses the NIH_SOURCE variable to find where the
# kernel build directory is (aka KV_OUT_DIR, see linux-info.eclass)
#
# then:
#
# @CODE
# CONFIG_CHECK="INPUT_FF_MEMLESS" # gamepad needs it to rumble
# MODULES_KERNEL_MIN=5.4 # needs features introduced in 5.4
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
# Alternatively, if using the package's build system directly is
# more convenient, a typical example could be:
#
# @CODE
# src_compile() {
#     MODULES_MAKEARGS+=(
#         NIH_KDIR="${KV_OUT_DIR}"
#         NIH_KSRC="${KV_DIR}"
#     )
#
#     emake "${MODULES_MAKEARGS[@]}"
# }
#
# src_install() {
#     emake "${MODULES_MAKEARGS[@]}" DESTDIR="${ED}" install
#     modules_post_process # strip->sign->compress
#
#     einstalldocs
# }
# @CODE
#
# Some extra make variables may be of interest:
#  - INSTALL_MOD_PATH: sometime used as DESTDIR
#  - INSTALL_MOD_DIR: equivalent to linux_moduleinto
#
# MODULES_MAKEARGS is set by the eclass to handle toolchain and,
# when installing, also attempts to disable automatic stripping,
# compression, signing, and depmod to let the eclass handle it.
#
# linux_domodule can alternatively be used to install a single module.
#
# (remember to ensure that linux-mod-r1_pkg_postinst is ran for depmod)

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_LINUX_MOD_R1_ECLASS} ]]; then
_LINUX_MOD_R1_ECLASS=1

inherit dist-kernel-utils edo linux-info multiprocessing toolchain-funcs

IUSE="dist-kernel modules-compress modules-sign +strip ${MODULES_OPTIONAL_IUSE}"

RDEPEND="
	sys-apps/kmod[tools]
	dist-kernel? ( virtual/dist-kernel:= )
"
DEPEND="
	virtual/linux-sources
"
BDEPEND="
	sys-apps/kmod[tools]
	modules-sign? (
		dev-libs/openssl
		virtual/pkgconfig
	)
"
IDEPEND="
	sys-apps/kmod[tools]
"

if [[ ${MODULES_INITRAMFS_IUSE} ]]; then
	inherit mount-boot-utils
	IUSE+=" ${MODULES_INITRAMFS_IUSE}"
	IDEPEND+="
		${MODULES_INITRAMFS_IUSE#+}? (
			sys-kernel/installkernel
		)
	"
fi

if [[ -n ${MODULES_OPTIONAL_IUSE} ]]; then
	: "${MODULES_OPTIONAL_IUSE#+}? ( | )"
	RDEPEND=${_/|/${RDEPEND}} DEPEND=${_/|/${DEPEND}} \
		BDEPEND=${_/|/${BDEPEND}} IDEPEND=${_/|/${IDEPEND}}
fi

# @ECLASS_VARIABLE: KERNEL_CHOST
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Can be set to the CHOST value to use when selecting the toolchain
# for building kernel modules.  This is similar to setting the kernel
# build system's CROSS_COMPILE variable minus the trailing dash.
#
# If this does not auto-select the desired toolchain, finer control
# can be achieved by setting the not directly documented (but valid)
# variables:
#
# KERNEL_{CC,CXX,LD,AR,NM,OBJCOPY,OBJDUMP,READELF,STRIP}
#
# If in doubt, do not set any of this.
#
# Default if unset: auto-detection, typically same as the current CHOST

# @ECLASS_VARIABLE: MODULES_EXTRA_EMAKE
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Extra arguments to pass to emake when building modules.
# Can contain arguments with quoted spaces, e.g.
# @CODE
# ..._EMAKE="KCFLAGS='-fzomg-optimize -fsuper-strict-aliasing' ..."
# @CODE

# @ECLASS_VARIABLE: MODULES_I_WANT_FULL_CONTROL
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# When set to a non-empty value, disables passing most of the eclass'
# toolchain defaults to emake when building modules.  Basic eclass
# requirements, ebuilds' modargs, and users' MODULES_EXTRA_EMAKE are
# still used.
#
# Primarily intended for expert users with modified kernel Makefiles
# that want the Makefile's values to be used by default.
#
# May want to look at KERNEL_CHOST before considering this.

# @ECLASS_VARIABLE: MODULES_INITRAMFS_IUSE
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# If set, adds the specified USE flag. When this flag is enabled the
# installed kernel modules are registered for inclusion in the dracut
# initramfs. Additionally, if distribution kernels are used
# (USE="dist-kernel") then these kernels are re-installed.
#
# The typical recommended value is "initramfs" or "+initramfs" (global
# IUSE).
#
# If MODULES_INITRAMFS_IUSE is not set, or the specified flag is not
# enabled, then the installed kernel modules are omitted from the
# dracut initramfs.

# @ECLASS_VARIABLE: MODULES_SIGN_HASH
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Used with USE=modules-sign.  Can be set to hash algorithm to use
# during signature generation.
#
# Rather than set this, it is recommended to select using the kernel's
# configuration to ensure proper support (e.g. CONFIG_MODULE_SIG_SHA256),
# and then it will be auto-detected here.
#
# Valid values: sha512,sha384,sha256,sha224,sha1
#
# Default if unset: kernel CONFIG_MODULE_SIG_HASH's value

# @ECLASS_VARIABLE: MODULES_SIGN_KEY
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Used with USE=modules-sign.  Can be set to the path of the private
# key in PEM format to use, or a PKCS#11 URI.
#
# If path is relative (e.g. "certs/name.pem"), it is assumed to be
# relative to the kernel build directory being used.
#
# If the key requires a passphrase or PIN, the used kernel sign-file
# utility recognizes the KBUILD_SIGN_PIN environment variable.  Be
# warned that the package manager may store this value in binary
# packages, database files, temporary files, and possibly logs.  This
# eclass unsets the variable after use to mitigate the issue (notably
# for shared binary packages), but use this with care.
#
# Default if unset: kernel CONFIG_MODULE_SIG_KEY's value which itself
# defaults to certs/signing_key.pem

# @ECLASS_VARIABLE: MODULES_SIGN_CERT
# @USER_VARIABLE
# @DESCRIPTION:
# Used with USE=modules-sign.  Can be set to the path of the X.509
# public key certificate to use.
#
# If path is relative (e.g. "certs/name.x509"), it is assumed to be
# relative to the kernel build directory being used.
: "${MODULES_SIGN_CERT:=certs/signing_key.x509}"

# @ECLASS_VARIABLE: MODULES_KERNEL_MAX
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to a kernel version (format: 1, 1.2, or 1.2.3), will print a
# warning if the used version is greater than (ver_test -gt) to this
# value using the same amount of version components (i.e. MAX=1.2
# allows 1.2.3, but MAX=1.2.2 does not).
#
# This should *only* be used for modules that are known to break
# frequently on kernel upgrades.  If setting this to a non-LTS kernel,
# then should also take care to test and update this value regularly
# with new major kernel releases not to let the warning become stale
# and ignored by users.
#
# Not fatal to allow users to try or self-patch easily, but the (large)
# warning is difficult to miss.  If need a fatal check for more serious
# issues (e.g. runtime filesystem corruption), please do it manually.
#
# This is intended to reduce the amount of bug reports for recurring
# expected issues that can be easily mitigated by using LTS kernels
# and waiting for new releases.
#
# If used, must be set before linux-mod-r1_pkg_setup is called.

# @ECLASS_VARIABLE: MODULES_KERNEL_MIN
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to a kernel version (format: 1, 1.2, or 1.2.3), will abort if
# the used version is less than (ver_test -lt) this value.
#
# Should only be used if known broken, or if upstream recommends a sane
# minimum.  Not particularly necessary for kernels that are no longer
# in the tree.
#
# If used, must be set before linux-mod-r1_pkg_setup is called.

# @ECLASS_VARIABLE: MODULES_OPTIONAL_IUSE
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# May contain a single flag to be added to IUSE optionally prefixed
# with a + sign to enable it by default.  Doing so makes *all* of
# linux-mod-r1's functions and dependencies a no-op unless the flag
# is enabled.  This includes phases, e.g. linux-mod-r1_pkg_setup will
# not process CONFIG_CHECK unless the flag is set.
#
# The typical recommended value is "+modules" (global IUSE).
#
# Note that modules being optional can be useful even if user space
# tools require them (e.g. installing in a chroot or prefix when the
# modules are loaded on the host, saves setting up linux sources).
# However, if tools are non-trivial to build, it may be preferable
# to split into two packages than use this variable due to requiring
# rebuilds every kernel upgrades.

# @ECLASS_VARIABLE: MODULES_MAKEARGS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Will be set after linux-mod-r1_pkg_setup has been called.  Contains
# arguments that should be passed to emake when building or installing
# modules.
#
# Modifying this variable is acceptable (e.g. to append kernel source
# arguments) but, if using linux-mod-r1_src_compile, setting modargs
# is the intended method seen as cleaner and less error-prone.

# @FUNCTION: linux-mod-r1_pkg_setup
# @DESCRIPTION:
# Required before using other functions from this eclass, and will:
#  1. run linux-info_pkg_setup (see linux-info.eclass)
#  -> implies processing CONFIG_CHECK, and providing KV_ variables
#    (MODULES and TRIM_UNUSED_KSYMS are always checked)
#  2. prepare toolchain to match the kernel
#  -> sets KERNEL_{CHOST,CC,CXX,LD,AR,NM,OBJCOPY,OBJDUMP,READELF,STRIP}
#  -> also sets MODULES_MAKEARGS array with, e.g. CC="${KERNEL_CC}"
#    (normally these should not be used directly, for custom builds)
#  3. perform various sanity checks to fail early on issues
linux-mod-r1_pkg_setup() {
	debug-print-function ${FUNCNAME[0]} "${@}"
	_MODULES_GLOBAL[ran:pkg_setup]=1
	_modules_check_function ${#} 0 0 || return 0

	if [[ -z ${ROOT} && ${MODULES_INITRAMFS_IUSE} ]] &&
		use dist-kernel && use ${MODULES_INITRAMFS_IUSE#+}
	then
		# Check, but don't die because we can fix the problem and then
		# emerge --config ... to re-run installation.
		nonfatal mount-boot_check_status
	fi

	[[ ${MERGE_TYPE} != binary ]] || return 0

	_modules_check_migration

	_modules_prepare_kernel
	_modules_prepare_sign
	_modules_prepare_toolchain

	_modules_set_makeargs

	_modules_sanity_gccplugins
}

# @FUNCTION: linux-mod-r1_src_compile
# @DESCRIPTION:
# Builds modules, see the eclass' example for a quick overview.
# Uses the variables modlist and modargs as described below:
#
# * local modlist=( ... ) - list of modules to build, set as:
#
#     module-name=install-dir:source-dir:build-dir:make-target
#
# > module-name: Resulting name, aka <module-name>.ko (required).
#
# > install-dir: Kernel modules sub-directory to install the module
# to (/lib/modules/version/<install-dir>/name.ko).  Will be used when
# run linux-mod-r1_src_install.  May want to consider the values of
# INSTALL_MOD_DIR(Makefile) or DEST_MODULE_LOCATION(dkms.conf) if it
# exists, but it can be anything.
#  -> Default: extra
#
# Warning: Changing this location may leave stale modules until a
# kernel upgrade as the package manager does not typically delete
# old modules and only does overwrite on rebuilds.
#
# > source-dir: Directory containing the Makefile to build the module.
# Path can be relative to the current directory or absolute.
#  -> Default: current directory
#
# > build-dir: Directory that will hold the built module-name.ko.
#  -> Default: same as source-dir's value
#
# > make-target: Almost always unneeded but, if defaults are not right,
# then can specify the Makefile's target(s) to build the module/extras.
# Multiple targets can be used with spaces, e.g. :"first second".
#  -> Default: specially tries modules, module, <name>.ko, default,
# all, empty target, and runs the first found usable
#
# Missing elements results in defaults being used, e.g. this is valid:
#   modlist=( name1 name2=:source name3=install::build )
#
# * local modargs=( ... ) - extra arguments to pass to emake
#
# Makefile should notably be inspected for which variable it uses
# to find the kernel's build directory then, e.g. KDIR="${KV_OUT_DIR}"
# as appropriate.  Note that typically want to pass KV_OUT_DIR(build)
# rather than KV_DIR(sources) if not both.  This allows users to do
# out-of-source kernel builds and still build modules.
#
# Passing common toolchain variables such as CC or LD is not needed
# here as they are passed by default.
#
# ---
#
# Allowed to be called multiple times with a different modlist if need
# different make arguments per modules or intermediate steps -- albeit,
# if atypical, may want to build manually (see eclass' example).
linux-mod-r1_src_compile() {
	debug-print-function ${FUNCNAME[0]} "${@}"
	_modules_check_function ${#} 0 0 || return 0

	[[ ${modlist@a} == *a* && ${#modlist[@]} -gt 0 ]] ||
		die "${FUNCNAME[0]} was called without a 'modlist' array"

	# run this again to verify built files access with src_compile's user
	_modules_sanity_kernelbuilt

	local -a emakeargs=( "${MODULES_MAKEARGS[@]}" )
	[[ ${modargs@a} == *a* ]] && emakeargs+=( "${modargs[@]}" )

	local -A built=()
	local build mod name target
	for mod in "${modlist[@]}"; do
		# note modlist was not made an associative array ([name]=) to preserve
		# ordering, but is still using = to improve readability
		name=${mod%%=*}
		[[ -n ${name} && ${name} != *:* ]] || die "invalid mod entry '${mod}'"

		# 0:install-dir 1:source-dir 2:build-dir 3:make-target(s)
		mod=${mod#"${name}"}
		IFS=: read -ra mod <<<"${mod#=}"
		[[ ${#mod[@]} -le 4 ]] || die "too many ':' in ${name}'s modlist"

		[[ ${mod[1]:=${PWD}} != /* ]] && mod[1]=${PWD}/${mod[1]}
		[[ ${mod[2]:=${mod[1]}} != /* ]] && mod[2]=${PWD}/${mod[2]}
		_MODULES_INSTALL[${mod[2]}/${name}.ko]=${mod[0]:-extra}

		pushd "${mod[1]}" >/dev/null || die

		if [[ -z ${mod[3]} ]]; then
			# guess between commonly used targets if none given, fallback to
			# an empty target without trying to see the error output
			for target in module{s,} "${name}".ko default all; do
				nonfatal emake "${emakeargs[@]}" -q "${target}" &>/dev/null
				if [[ ${?} -eq 1 ]]; then
					mod[3]=${target}
					break
				fi
			done
		fi

		# sometime modules are all from same source dir and built all at once,
		# make will not rebuild either way but can skip the unnecessary noise
		build=
		for target in ${mod[3]:-&}; do
			if ! has "${target}" ${built[${mod[1]}]}; then
				build=1
				built[${mod[1]}]+=" ${target} "
			fi
		done

		if [[ ${build} ]]; then
			einfo "Building ${name} module in ${mod[1]} ..."

			# allow word splitting for rare cases of multiple targets
			emake "${emakeargs[@]}" ${mod[3]}
		else
			einfo "Building ${name} module in ${mod[1]} ... already done."
		fi

		popd >/dev/null || die
	done
}

# @FUNCTION: linux-mod-r1_src_install
# @DESCRIPTION:
# Installs modules built by linux-mod-r1_src_compile using
# linux_domodule, then runs modules_post_process and einstalldocs.
linux-mod-r1_src_install() {
	debug-print-function ${FUNCNAME[0]} "${@}"
	_modules_check_function ${#} 0 0 || return 0

	(( ${#_MODULES_INSTALL[@]} )) ||
		die "${FUNCNAME[0]} was called without running linux-mod-r1_src_compile"

	(
		for mod in "${!_MODULES_INSTALL[@]}"; do
			linux_moduleinto "${_MODULES_INSTALL[${mod}]}"
			linux_domodule "${mod}"
		done
	)

	modules_post_process

	einstalldocs
}

# @FUNCTION: linux-mod-r1_pkg_postinst
# @DESCRIPTION:
# Updates module dependencies using depmod.
linux-mod-r1_pkg_postinst() {
	debug-print-function ${FUNCNAME[0]} "${@}"
	_modules_check_function ${#} 0 0 || return 0

	dist-kernel_compressed_module_cleanup "${EROOT}/lib/modules/${KV_FULL}"
	_modules_update_depmod

	if [[ -z ${ROOT} && ${MODULES_INITRAMFS_IUSE} ]] &&
		use dist-kernel && use ${MODULES_INITRAMFS_IUSE#+}
	then
		dist-kernel_reinstall_initramfs "${KV_DIR}" "${KV_FULL}"
	fi

	if has_version virtual/dist-kernel && ! use dist-kernel; then
		ewarn "virtual/dist-kernel is installed, but USE=\"dist-kernel\""
		ewarn "is not enabled for ${CATEGORY}/${PN}."
		ewarn "It's recommended to globally enable the dist-kernel USE flag"
		ewarn "to automatically trigger initramfs rebuilds on kernel updates"
	fi

	# post_process ensures modules were installed and that the eclass' USE
	# are likely not no-ops (unfortunately postinst itself may be missed)
	[[ -v _MODULES_GLOBAL[ran:post_process] ]] ||
		eqawarn "QA Notice: neither linux-mod-r1_src_install nor modules_post_process were used"
}

# @FUNCTION: linux_domodule
# @USAGE: <module>...
# @DESCRIPTION:
# Installs Linux modules (.ko files).
#
# See also linux_moduleinto.
linux_domodule() {
	debug-print-function ${FUNCNAME[0]} "${@}"
	_modules_check_function ${#} 1 '' "<module>..." || return 0
	(
		# linux-mod-r0 formerly supported INSTALL_MOD_PATH (bug #642240), but
		# this been judged messy to integrate consistently as not everything
		# uses this function and build systems sometime mix it with DESTDIR
		# (try ROOT if need to install somewhere else instead)
		insinto "/lib/modules/${KV_FULL}/${_MODULES_GLOBAL[moduleinto]:-extra}"
		doins "${@}"
	)
}

# @FUNCTION: linux_moduleinto
# @USAGE: <install-dir>
# @DESCRIPTION:
# Directory to install modules into when calling linux_domodule.
# Relative to kernel modules path as in:
# ${ED}/lib/modules/${KV_FULL}/<install-dir>
#
# Can contain subdirectories, e.g. kernel/fs.
#
# If not called, defaults to "extra".  On the kernel build system,
# this is like setting INSTALL_MOD_DIR which has the same default
# for external modules.
linux_moduleinto() {
	debug-print-function ${FUNCNAME[0]} "${@}"
	_modules_check_function ${#} 1 1 "<install-dir>" || return 0
	_MODULES_GLOBAL[moduleinto]=${1}
}

# @FUNCTION: modules_post_process
# @USAGE: [<path>]
# @DESCRIPTION:
# Strip, sign, verify, and compress all .ko modules found under
# <path>.  Should typically *not* be called directly as it will
# be run by linux-mod-r1_src_install.  This is intended for use
# when modules were installed some other way.
#
# <path> should exist under ${ED}.
# Defaults to /lib/modules/${KV_FULL}.
#
# Filenames may change due to compression, so any operations on
# these should be performed prior.
#
# Warning: This will abort if no modules are found, which can happen
# if modules were unexpectedly pre-compressed possibly due to using
# make install without passing MODULES_MAKEARGS to disable it.
modules_post_process() {
	debug-print-function ${FUNCNAME[0]} "${@}"
	_modules_check_function ${#} 0 1 '[<path>]' || return 0
	[[ ${EBUILD_PHASE} == install ]] ||
		die "${FUNCNAME[0]} can only be called in the src_install phase"

	local path=${ED}${1-/lib/modules/${KV_FULL}}
	local -a mods
	[[ -d ${path} ]] && mapfile -td '' mods < <(
		find "${path}" -type f -name '*.ko' -print0 || die
	)
	(( ${#mods[@]} )) ||
		die "${FUNCNAME[0]} was called with no installed modules under ${path}"

	# TODO?: look into re-introducing after verifying it works as expected,
	# formerly omitted because dracut's 90kernel-modules-extra parses depmod.d
	# files directly and assumes should include its modules but we now create
	# dracut omit files that *hopefully* prevent this
#	_modules_process_depmod.d "${mods[@]##*/}"

	_modules_process_dracut.conf.d "${mods[@]##*/}"
	_modules_process_strip "${mods[@]}"
	_modules_process_sign "${mods[@]}"
	_modules_sanity_modversion "${mods[@]}" # after strip/sign in case broke it
	_modules_process_compress "${mods[@]}"

	_MODULES_GLOBAL[ran:post_process]=1
}

# @ECLASS_VARIABLE: _MODULES_GLOBAL
# @INTERNAL
# @DESCRIPTION:
# General use associative array to avoid defining separate globals.
declare -gA _MODULES_GLOBAL=()

# @ECLASS_VARIABLE: _MODULES_INSTALL
# @INTERNAL
# @DESCRIPTION:
# List of modules from linux-mod-r1_src_compile to be installed.
declare -gA _MODULES_INSTALL=()

# @FUNCTION: _modules_check_function
# @USAGE: [<args-count> <args-min> <args-max> [<usage-string>]]
# @RETURN: 0 or 1 if caller should do nothing
# @INTERNAL
# @DESCRIPTION:
# Checks for MODULES_OPTIONAL_IUSE, and aborts if amount of arguments
# does not add up or if it was called before linux-mod-r1_pkg_setup.
_modules_check_function() {
	[[ -z ${MODULES_OPTIONAL_IUSE} ]] ||
		use "${MODULES_OPTIONAL_IUSE#+}" || return 1

	[[ ${#} == 0 || ${1} -ge ${2} && ( ! ${3} || ${1} -le ${3} ) ]] ||
		die "Usage: ${FUNCNAME[1]} ${4-(no arguments)}"

	[[ -v _MODULES_GLOBAL[ran:pkg_setup] ]] ||
		die "${FUNCNAME[1]} was called without running linux-mod-r1_pkg_setup"
}

# @FUNCTION: _modules_check_migration
# @INTERNAL
# @DESCRIPTION:
# Aborts if see obsolete variables from the linux-mod-r0 eclass being
# used, likely due to an incomplete migration.  This function should
# eventually be removed after linux-mod-r0 is @DEAD not to fail for
# nothing if users happen to have these in their environment given the
# naming for some is a bit generic.
_modules_check_migration() {
	_modules_check_var() {
		[[ -z ${!1} ]] ||
			die "${1} is obsolete, see ${2} in linux-mod-r1 eclass docs"
	}
	# the 'I' on this one is notably sneaky and could silently be ignored
	_modules_check_var MODULES_OPTIONAL_USE MODULES_OPTIONAL_IUSE
	_modules_check_var MODULES_OPTIONAL_USE_IUSE_DEFAULT MODULES_OPTIONAL_IUSE
	_modules_check_var BUILD_PARAMS modargs
	_modules_check_var BUILD_TARGETS modlist
	_modules_check_var MODULE_NAMES modlist
	[[ -z ${!MODULESD_*} ]] ||
		die "MODULESD_* variables are no longer supported, replace by handcrafted .conf files if needed"

	# Ignored variables:
	# - BUILD_FIXES: seen in some ebuilds but was undocumented and linux-info
	#   still sets it preventing from blocking it entirely
	# - ECONF_PARAMS: documented but was a no-op in linux-mod too
}

# @FUNCTION: _modules_prepare_kernel
# @INTERNAL
# @DESCRIPTION:
# Handles linux-info bits to provide usable sources, KV_ variables,
# and CONFIG_CHECK use.
_modules_prepare_kernel() {
	# The modules we build are specific to each kernel version, we don't
	# want to reset the environment to use the user selected kernel version.
	# Bug 931213, 926063
	SKIP_KERNEL_BINPKG_ENV_RESET=1

	get_version

	# linux-info allows skipping checks if SKIP_KERNEL_CHECK is set and
	# then require_configured_kernel will not abort, but no sources means
	# 100% failure for building modules and so just abort now (the proper
	# way to allow skipping sources here is MODULES_OPTIONAL_IUSE)
	[[ -n ${KV_FULL} ]] ||
		die "kernel sources are required to build kernel modules"

	require_configured_kernel

	_modules_sanity_kernelbuilt
	_modules_sanity_kernelversion

	# note: modules-specific check_modules_supported could probably be
	# removed from linux-info in the future as this is a sufficient check
	local CONFIG_CHECK="${CONFIG_CHECK} MODULES"

	# kernel will not typically know about symbols we use (bug #591832),
	# but stay non-fatal if kernel has an exception list set (bug #759238)
	# note: possible to bypass either way with CHECKCONFIG_DONOTHING=1
	if [[ $(linux_chkconfig_string UNUSED_KSYMS_WHITELIST) == \"+(?)\" ]]; then
		CONFIG_CHECK+=" ~!TRIM_UNUSED_KSYMS"
	else
		CONFIG_CHECK+=" !TRIM_UNUSED_KSYMS"
	fi

	linux-info_pkg_setup
}

# @FUNCTION: _modules_prepare_sign
# @INTERNAL
# @DESCRIPTION:
# Determines arguments to pass to sign-file (hash/keys), and performs
# basic sanity checks to abort early if signing does not look possible.
_modules_prepare_sign() {
	use modules-sign || return 0

	_modules_sign_die() {
		eerror "USE=modules-sign requires additional configuration, please see the"
		eerror "kernel[1] documentation and the linux-mod-r1 eclass[2] user variables."
		eerror "[1] https://www.kernel.org/doc/html/v${KV_MAJOR}.${KV_MINOR}/admin-guide/module-signing.html"
		eerror "[2] https://devmanual.gentoo.org/eclass-reference/linux-mod-r1.eclass/index.html"
		die "USE=modules-sign is set but ${*}"
	}

	linux_chkconfig_present MODULE_SIG ||
		_modules_sign_die "CONFIG_MODULE_SIG is not set in the kernel"

	if [[ -z ${MODULES_SIGN_HASH} ]]; then
		: "$(linux_chkconfig_string MODULE_SIG_HASH)"
		MODULES_SIGN_HASH=${_//\"}
		[[ -n ${MODULES_SIGN_HASH} ]] ||
			_modules_sign_die "CONFIG_MODULE_SIG_HASH is not set in the kernel"
	fi

	if [[ -z ${MODULES_SIGN_KEY} ]]; then
		: "$(linux_chkconfig_string MODULE_SIG_KEY)"
		MODULES_SIGN_KEY=${_//\"}
		[[ -n ${MODULES_SIGN_KEY} ]] ||
			_modules_sign_die "CONFIG_MODULE_SIG_KEY is not set in the kernel"
	fi

	[[ ${MODULES_SIGN_KEY} != @(/|pkcs11:)* ]] &&
		MODULES_SIGN_KEY=${KV_OUT_DIR}/${MODULES_SIGN_KEY}
	[[ ${MODULES_SIGN_CERT} != /* ]] &&
		MODULES_SIGN_CERT=${KV_OUT_DIR}/${MODULES_SIGN_CERT}

	# assumes users know what they are doing if using a pkcs11 URI
	[[ ${MODULES_SIGN_KEY} == pkcs11:* || -f ${MODULES_SIGN_KEY} ]] ||
		_modules_sign_die "the private key '${MODULES_SIGN_KEY}' was not found"
	[[ -f ${MODULES_SIGN_CERT} ]] ||
		_modules_sign_die "the public key certificate '${MODULES_SIGN_CERT}' was not found"
}

# @FUNCTION: _modules_prepare_toolchain
# @INTERNAL
# @DESCRIPTION:
# Sets KERNEL_{CC,CXX,LD,AR,NM,OBJCOPY,OBJDUMP,READELF,STRIP} based on
# the kernel configuration and KERNEL_CHOST (also set if missing) that
# *should* be usable to build modules.
#
# Tries to match compiler type (gcc or clang), and major version.  Will
# inform if matching was not possible likely due to the compiler being
# uninstalled.  Users can set KERNEL_ variables themselves to override.
#
# These variables are normally manipulated by the kernel's LLVM=1 with
# the exception of CXX that is included anyway given *some* out-of-tree
# modules use it, e.g. nvidia-drivers[kernel-open].
_modules_prepare_toolchain() {
	# note that the kernel adds -m32/-m64/-m elf_x86_64/etc... for, e.g.
	# toolchains defaulting to x32, but may need automagic here if need
	# a different toolchain such as sys-devel/kgcc64
	[[ -z ${KERNEL_CHOST} ]] && linux_chkconfig_present 64BIT &&
		case ${CHOST} in
			# matching kernel-build.eclass, see for details
			hppa2.0-*) KERNEL_CHOST=${CHOST/2.0/64};;
		esac

	# recognizing KERNEL_CHOST given CROSS_COMPILE seems too generic here,
	# but should rarely be necessary unless different userland and kernel
	: "${KERNEL_CHOST:=${CHOST}}"

	einfo "Preparing ${KERNEL_CHOST} toolchain for kernel modules (override with KERNEL_CHOST) ..."

	_modules_tc_best() {
		[[ -z ${!1} ]] && read -r ${1} < <(type -P -- "${@:2}")
	}

	local gccv clangv tool
	if linux_chkconfig_present CC_IS_GCC; then
		gccv=$(linux_chkconfig_string GCC_VERSION)
		gccv=${gccv::2} # major version, will break on gcc-100...
		# chost-gcc-ver > chost-gcc > gcc-ver > gcc
		_modules_tc_best KERNEL_CC {"${KERNEL_CHOST}-",}gcc{"-${gccv}",}
		_modules_tc_best KERNEL_CXX {"${KERNEL_CHOST}-",}g++{"-${gccv}",}
		# unknown what was used exactly here, but prefer non-llvm with gcc
		for tool in AR NM OBJCOPY OBJDUMP READELF STRIP; do
			_modules_tc_best KERNEL_${tool} \
				{"${KERNEL_CHOST}-",}{gcc-,}${tool,,}
		done
	elif linux_chkconfig_present CC_IS_CLANG; then
		clangv=$(linux_chkconfig_string CLANG_VERSION)
		clangv=${clangv::2}
		# like gcc, but try directories to get same version on all tools
		# (not using get_llvm_prefix to avoid conflicts with ebuilds using
		# llvm slots for non-modules reasons, e.g. sets llvm_check_deps)
		_modules_tc_best KERNEL_CC \
			{"${BROOT}/usr/lib/llvm/${clangv}/bin/",}{"${KERNEL_CHOST}-",}clang{"-${clangv}",}
		_modules_tc_best KERNEL_CXX \
			{"${BROOT}/usr/lib/llvm/${clangv}/bin/",}{"${KERNEL_CHOST}-",}clang++{"-${clangv}",}
		for tool in AR NM OBJCOPY OBJDUMP READELF STRIP; do
			_modules_tc_best KERNEL_${tool} \
				{"${BROOT}/usr/lib/llvm/${clangv}/bin/",}{"${KERNEL_CHOST}-",}{llvm-,}${tool,,}
		done
	fi

	if linux_chkconfig_present LD_IS_BFD; then
		_modules_tc_best KERNEL_LD {"${KERNEL_CHOST}-",}ld.bfd
	elif linux_chkconfig_present LD_IS_LLD; then
		# also match with clang if it was used
		_modules_tc_best KERNEL_LD \
			{${clangv+"${BROOT}/usr/lib/llvm/${clangv}/bin/"},}{"${KERNEL_CHOST}-",}ld.lld
	fi

	# if any variables are still empty, fallback to normal defaults
	local CHOST=${KERNEL_CHOST}
	: "${KERNEL_CC:=$(tc-getCC)}"
	: "${KERNEL_CXX:=$(tc-getCXX)}"
	: "${KERNEL_LD:=$(tc-getLD)}"
	: "${KERNEL_AR:=$(tc-getAR)}"
	: "${KERNEL_NM:=$(tc-getNM)}"
	: "${KERNEL_OBJCOPY:=$(tc-getOBJCOPY)}"
	: "${KERNEL_OBJDUMP:=$(tc-getOBJDUMP)}"
	: "${KERNEL_READELF:=$(tc-getREADELF)}"
	: "${KERNEL_STRIP:=$(tc-getSTRIP)}"

	# for toolchain-funcs, uses CPP > CC but set both not to make assumptions
	local CC=${KERNEL_CC} CPP="${KERNEL_CC} -E" LD=${KERNEL_LD}

	# show results, skip line wrap to avoid standing out too much
	einfo "Toolchain picked for kernel modules (override with KERNEL_CC, _LD, ...):"\
		"'${KERNEL_CC}' '${KERNEL_CXX}' '${KERNEL_LD}' '${KERNEL_AR}'"\
		"'${KERNEL_NM}' '${KERNEL_OBJCOPY}' '${KERNEL_OBJDUMP}'"\
		"'${KERNEL_READELF}' '${KERNEL_STRIP}'"

	# hack: kernel adds --thinlto-cache-dir to KBUILD_LDFLAGS with ThinLTO
	# resulting in sandbox violations and we cannot safely override that
	# variable, using *both* {LDFLAGS_MODULE,ldflags-y}=--thinlto-cache-dir=
	# can work but raises concerns about breaking packages that may use these
	if linux_chkconfig_present LTO_CLANG_THIN && tc-ld-is-lld; then
		KERNEL_LD=${T}/linux-mod-r1_ld.lld
		printf '#!/usr/bin/env sh\nexec %q "${@}" --thinlto-cache-dir=\n' \
			"${LD}" > "${KERNEL_LD}" || die
		chmod +x -- "${KERNEL_LD}" || die
	fi

	# warn if final picked CC type or major version is mismatching, arguably
	# should be fatal but not forcing given it is not *always* an issue
	local warn
	if [[ -v gccv ]]; then
		if ! tc-is-gcc; then
			warn="gcc-${gccv} but\n         '${KERNEL_CC}' is not gcc"
		elif [[ $(gcc-major-version) -ne "${gccv}" ]]; then
			warn="gcc-${gccv} but\n         '${KERNEL_CC}' is gcc-$(gcc-major-version)"
		fi
	elif [[ -v clangv ]]; then
		if ! tc-is-clang; then
			warn="clang-${clangv} but\n         '${KERNEL_CC}' is not clang"
		elif [[ $(clang-major-version) -ne "${clangv}" ]]; then
			warn="clang-${clangv} but\n         '${KERNEL_CC}' is clang-$(clang-major-version)"
		fi
	fi

	if [[ -v warn ]]; then
		ewarn
		ewarn "Warning: kernel ${KV_FULL} is built with ${warn}"
		ewarn "This *could* result in build issues or other incompatibilities."
		ewarn "It is recommended to either \`make clean\` and rebuild the kernel"
		ewarn "with the current toolchain (for distribution kernels, re-installing"
		ewarn "will do the same), or set the KERNEL_CC variable to point to the"
		ewarn "same compiler. Note that when it is available, auto-selection is"
		ewarn "attempted making the latter rarely needed."
		ewarn
	fi
}

# @FUNCTION: _modules_process_compress
# @USAGE: <module>...
# @INTERNAL
# @DESCRIPTION:
# If enabled in the kernel configuration, this compresses the given
# modules using the same format.
_modules_process_compress() {
	use modules-compress || return 0

	local -a compress
	if linux_chkconfig_present MODULE_COMPRESS_XZ; then
		compress=(
			xz -q
			--memlimit-compress=50%
			--threads="$(makeopts_jobs)"
			# match options from kernel's Makefile.modinst (bug #920837)
			--check=crc32
			--lzma2=dict=1MiB
		)
	elif linux_chkconfig_present MODULE_COMPRESS_GZIP; then
		if type -P pigz &>/dev/null; then
			compress=(pigz -p"$(makeopts_jobs)")
		else
			compress=(gzip)
		fi
	elif linux_chkconfig_present MODULE_COMPRESS_ZSTD; then
		compress=(zstd -qT"$(makeopts_jobs)" --rm)
	else
		die "USE=modules-compress enabled but no MODULE_COMPRESS* configured"
	fi

	# could fail, assumes have commands that were needed for the kernel
	einfo "Compressing modules (matching the kernel configuration) ..."
	edob "${compress[@]}" -- "${@}"
}

# @FUNCTION: _modules_process_depmod.d
# @USAGE: <relative-module-path>...
# @INTERNAL
# @DESCRIPTION:
# Generate a depmod.d file to ensure priority if duplicate modules
# exist, such as stale modules in different directories, or to
# override the kernel's own modules.
_modules_process_depmod.d() {
	(
		[[ ${SLOT%/*} == 0 ]] && slot= || slot=-${SLOT%/*}
		insinto /lib/depmod.d
		newins - ${PN}${slot}.conf < <(
			echo "# Automatically generated by linux-mod-r1.eclass for ${CATEGORY}/${PN}"
			for mod; do
				[[ ${mod} =~ ^(.+)/(.+).ko$ ]] &&
					echo "override ${BASH_REMATCH[2]} ${KV_FULL} ${BASH_REMATCH[1]}"
			done
		)
	)
}

# @FUNCTION: _modules_process_dracut.conf.d
# @USAGE: <module>...
# @INTERNAL
# @DESCRIPTION:
# Create dracut.conf.d snippet defining if module should be included in the
# initramfs.
_modules_process_dracut.conf.d() {
	(
		insinto /usr/lib/dracut/dracut.conf.d
		[[ ${MODULES_INITRAMFS_IUSE} ]] && use ${MODULES_INITRAMFS_IUSE#+} &&
			: add || : omit
		newins - 10-${PN}.conf <<<"${_}_drivers+=\" ${*%.ko} \""
	)
}

# @FUNCTION: _modules_process_sign
# @USAGE: <module>...
# @INTERNAL
# @DESCRIPTION:
# Cryptographically signs the given modules when USE=modules-sign is
# enabled.
_modules_process_sign() {
	use modules-sign || return 0

	# scripts/sign-file used to be a perl script but is now written in C,
	# and it could either be missing or broken given it links with openssl
	# (no subslot rebuilds on kernel sources), trivial to compile regardless
	local sign=
	if [[ -f ${KV_DIR}/scripts/sign-file.c ]]; then
		sign=${T}/linux-mod-r1_sign-file
		(
			# unfortunately using the kernel's Makefile is inconvenient (no
			# simple build target for this), may need revisiting on changes
			einfo "Compiling sign-file ..."
			tc-export_build_env
			nonfatal edob $(tc-getBUILD_CC) ${BUILD_CFLAGS} ${BUILD_CPPFLAGS} \
				$($(tc-getBUILD_PKG_CONFIG) --cflags libcrypto) \
				${BUILD_LDFLAGS} -o "${sign}" "${KV_DIR}"/scripts/sign-file.c \
				$($(tc-getBUILD_PKG_CONFIG) --libs libcrypto || echo -lcrypto)
		) || {
			einfo "Trying fallback ..."
			sign=
		}
	fi

	if [[ -z ${sign} ]]; then
		if [[ -x ${KV_OUT_DIR}/scripts/sign-file ]]; then
			sign=${KV_OUT_DIR}/scripts/sign-file # try if built
		elif [[ -x ${KV_DIR}/scripts/sign-file ]]; then
			sign=${KV_DIR}/scripts/sign-file # old kernel (<linux-4.4)
		else
			die "USE=modules-sign is set but '${KV_DIR}/scripts/sign-file.c' is not usable"
		fi
	fi

	einfo "Signing modules ..."

	# good odds the private key has limited access, and with the kernel's
	# automated method it is likely to be -rw------- root:root (but is
	# rarely an issue given src_install *normally* runs as root)
	[[ ${MODULES_SIGN_KEY} == pkcs11:* || -r ${MODULES_SIGN_KEY} ]] ||
		die "USE=modules-sign is set but lacking read access to the signing key at '${MODULES_SIGN_KEY}'"

	local mod
	for mod; do
		edob "${sign}" "${MODULES_SIGN_HASH}" "${MODULES_SIGN_KEY}" \
			"${MODULES_SIGN_CERT}" "${mod}"
	done

	# unset to at least be out of the environment file in, e.g. shared binpkgs
	unset KBUILD_SIGN_PIN
}

# @FUNCTION: _modules_process_strip
# @USAGE: <module>...
# @INTERNAL
# @DESCRIPTION:
# Strips the given modules of unneeded symbols when USE=strip is
# enabled, and informs the package manager not to regardless.
_modules_process_strip() {
	# letting the package manager handle this complicates scenarios
	# where we want to either compress the pre-stripped module, or
	# sign the module without its signature becoming invalid on merge
	dostrip -x "${@#"${ED}"}"

	if use strip; then
		einfo "Stripping modules ..."
		edob "${KERNEL_STRIP}" --strip-unneeded -- "${@}"
	fi
}

# @FUNCTION: _modules_sanity_gccplugins
# @INTERNAL
# @DESCRIPTION:
# Performs a basic build test to detect GCC plugins mismatch issues
# and, if so, aborts with explanation given it often confuses users.
#
# Using mismatching gcc can sometime work to build modules, but if
# GCC plugins are enabled it will almost always be an error.
#
# Note: may need occasional review to ensure the test still works by:
# enabling a GCC plugin in the kernel, building with older GCC,
# then building a module by setting KERNEL_CC=gcc-<major-version+1>.
_modules_sanity_gccplugins() {
	linux_chkconfig_present GCC_PLUGINS || return 0

	local tmp=${T}/linux-mod-r1_gccplugins
	mkdir -p -- "${tmp}" || die

	echo "obj-m += test.o" > "${tmp}"/Kbuild || die
	:> "${tmp}"/test.c || die

	# always fails, but interested in the stderr messages
	local output=$(
		cd -- "${KV_OUT_DIR}" && # fwiw skip non-POSIX -C in eclasses
			LC_ALL=C nonfatal emake "${MODULES_MAKEARGS[@]}" M="${tmp}" \
				2>&1 >/dev/null
	)

	if [[ ${output} == *"error: incompatible gcc/plugin version"* ]]; then
		eerror "GCC_PLUGINS is enabled in the kernel and plugin version mismatch issues"
		eerror "have been detected. Please \`make clean\` and rebuild the kernel using"
		eerror "the current version of GCC (or re-install for distribution kernels)."
		die "kernel ${KV_FULL} needs to be rebuilt"
	fi
}

# @FUNCTION: _modules_sanity_kernelbuilt
# @INTERNAL
# @DESCRIPTION:
# Checks if the kernel seems fully built by having a Module.symvers
# that is also readable, abort otherwise.
#
# About readability, occasionally users build their kernel as root with
# umask 0077 and then the package manager's user cannot read built files
# leaving them confused.
#
# Given user and access can very between phases (notably src_compile),
# it makes sense to run this check more than once.
#
# Note:
# This is an alternate version of linux-info's check_kernel_built
# which probably will not need to exist there if linux-mod-r0 is
# gone, error it gives is also modules-specific and fits better here.
#
# The old check_kernel_built checks version.h and suggests running
# modules_prepare if missing, but that does not create Module.symvers.
# Nowadays the kernel makes unresolved symbols fatal by default
# meaning that all modules will fail unless KBUILD_MODPOST_WARN=1
# which seem questionable to support.  So rather than version.h, this
# checks and require Module.symvers, and suggests a full build if
# missing (if really must, users can bypass by touching the file).
# nvidia-drivers (for one) further checks this file directly to do
# configure tests that will break badly without.
_modules_sanity_kernelbuilt() {
	local symvers=${KV_OUT_DIR}/Module.symvers

	if [[ ! -f ${symvers} ]]; then
		eerror "'${symvers}' was not found implying that the"
		eerror "linux-${KV_FULL} tree at that location has not been built."
		eerror
		eerror "Please verify that this is the intended kernel version, then perform"
		eerror "a full build[1] (i.e. make && make modules_install && make install)."
		eerror
		eerror "Alternatively, consider a distribution kernel[2] that does not need"
		eerror "these manual steps (e.g. sys-kernel/gentoo-kernel or gentoo-kernel-bin)."
		eerror
		eerror "[1] https://wiki.gentoo.org/wiki/Kernel/Configuration#Build"
		eerror "[2] https://wiki.gentoo.org/wiki/Project:Distribution_Kernel"
		die "built kernel sources are required to build kernel modules"
	fi

	if [[ ! -r ${symvers} ]]; then
		eerror "'${symvers}' exists but cannot be read by the"
		eerror "user id(${EUID}) of the package manager, likely implying no world"
		eerror "read access permissions:"
		eerror
		eerror "    $(ls -l -- "${symvers}")"
		eerror
		eerror "Causes may vary, but a common one is building the kernel with a umask"
		eerror "value of '0077' rather than the more typical '0022' (run the \`umask\`"
		eerror "command to confirm, as root if was building the kernel using it)."
		eerror
		eerror "Many other files are likely affected and will lead to build failures."
		eerror "It is recommended to clean the sources and rebuild with \`umask 0022\`"
		eerror "rather than attempt to fix the permissions manually."
		die "no read access permission to the generated kernel files"
	fi
}

# @FUNCTION: _modules_sanity_kernelversion
# @INTERNAL
# @DESCRIPTION:
# Prints a warning if the kernel version is greater than to
# MODULES_KERNEL_MAX (while only considering same amount of version
# components), or aborts if it is less than MODULES_KERNEL_MIN.
#
# With USE=dist-kernel, also warn if virtual/dist-kernel is of a
# different version than the one being built against.
_modules_sanity_kernelversion() {
	local kv=${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}

	if [[ -n ${MODULES_KERNEL_MIN} ]] &&
		ver_test "${kv}" -lt "${MODULES_KERNEL_MIN}"
	then
		eerror "${P} requires a kernel version of at least >=${MODULES_KERNEL_MIN},"
		eerror "but the current kernel is ${KV_FULL}. Please update."
		die "kernel ${KV_FULL} is too old"
	fi

	if [[ -n ${MODULES_KERNEL_MAX} ]]; then
		: "${MODULES_KERNEL_MAX//[^.]/}"
		local -i count=${#_}

		if ver_test "$(ver_cut 1-$((count+1)) "${kv}")" \
			-gt "${MODULES_KERNEL_MAX}"
		then
			# add .x to 1 missing component to make, e.g. <=1.2.x more natural,
			# not <1.3 given users sometimes see it as 1.3 support at a glance
			local max=${MODULES_KERNEL_MAX}
			[[ ${count} -lt 2 ]] && max+=.x

			ewarn
			ewarn " *** WARNING *** "
			ewarn
			ewarn "${PN} is known to break easily with new kernel versions and,"
			ewarn "with the current kernel (${KV_FULL}), it was either hardly"
			ewarn "tested or is known broken. It is recommended to use one of:"
			ewarn
			# fwiw we do not know what is *actually* used or wanted even with
			# the USE, so stay a bit vague and always mention both dist+sources
			if use dist-kernel; then
				ewarn "    <=virtual/dist-kernel-${max} or"
			else
				ewarn "    <=sys-kernel/gentoo-kernel-${max} or"
			fi
			ewarn "    <=sys-kernel/gentoo-sources-${max}"
			ewarn
			ewarn "or equivalent rather than file downstream bug reports if run into"
			ewarn "issues, then wait for upstream fixes and a new release. Ideally,"
			ewarn "with out-of-tree modules, use an LTS (Long Term Support) kernel"
			ewarn "branch[1]. If in doubt, Gentoo's stable kernels are always LTS"
			ewarn "and can be easily used even on ~testing systems."
			ewarn
			ewarn "[1] https://www.kernel.org/category/releases.html"
			ewarn
		fi
	fi

	if use dist-kernel &&
		! has_version "~virtual/dist-kernel-${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}"
	then
		ewarn
		ewarn "The kernel modules in ${CATEGORY}/${PN} are being built for"
		ewarn "kernel version ${KV_FULL}. But this does not match the"
		ewarn "installed version of virtual/dist-kernel."
		ewarn
		ewarn "If this is not intentional, the problem may be corrected by"
		ewarn "using \"eselect kernel\" to set the default kernel version to"
		ewarn "the same version as the installed version of virtual/dist-kernel."
		ewarn
		ewarn "If the distribution kernel is being downgraded, ensure that"
		ewarn "virtual/dist-kernel is also downgraded to the same version"
		ewarn "before rebuilding external kernel modules."
		ewarn
	fi
}

# @FUNCTION: _modules_sanity_modversion
# @USAGE: <module>...
# @INTERNAL
# @DESCRIPTION:
# Checks if the passed module(s) do not seem obviously broken and the
# builtin versions match ${KV_FULL}, otherwise die with an explanation.
#
# If receive a bug with a version error, an easy way to reproduce is to
# set KERNEL_DIR with the sources of a different kernel version than
# both the ones pointed by /usr/src/linux and `uname -r`.  Refer to
# linux-mod-r1_src_compile's modargs in the eclass docs for fixing.
_modules_sanity_modversion() {
	local mod ver
	for mod; do
		# modinfo can read different-arch modules, being fatal *should* be safe
		# and serve as a basic sanity check to ensure the module is valid
		read -rd ' ' ver < <(
			LC_ALL=C modinfo -F vermagic -- "${mod}" ||
				die "modinfo failed to read module '${mod}' (broken module?)"
		)
		[[ -n ${ver} ]] ||
				die "modinfo found no kernel version in '${mod}' (broken module?)"

		if [[ ${ver} != "${KV_FULL}" ]]; then
			eerror "A module seem to have been built for kernel version '${ver}'"
			eerror "while it was meant for '${KV_FULL}'. This may indicate an"
			eerror "ebuild issue (e.g. used runtime \`uname -r\` kernel rather than"
			eerror "the chosen sources). Please report this to the ebuild's maintainer."
			die "module and source version mismatch in '${mod}'"
		fi
	done
}

# @FUNCTION: _modules_set_makeargs
# @INTERNAL
# @DESCRIPTION:
# Sets the MODULES_MAKEARGS global array.
_modules_set_makeargs() {
	MODULES_MAKEARGS=(
		ARCH="$(tc-arch-kernel)"

		V=1
		# normally redundant with V, but some custom Makefiles override it
		KBUILD_VERBOSE=1

		# unrealistic when building modules that often have slow releases,
		# but note that the kernel will still pass some -Werror=bad-thing
		CONFIG_WERROR=

		# these are only needed if using these arguments for installing, lets
		# eclass handle strip, sign, compress, and depmod (CONFIG_ should
		# have no impact on building, only used by Makefile.modinst)
		CONFIG_MODULE_{SIG_ALL,COMPRESS_{GZIP,XZ,ZSTD}}=
		DEPMOD=true #916587
		STRIP=true
	)

	if [[ ! ${MODULES_I_WANT_FULL_CONTROL} ]]; then
		# many of these are unlikely to be useful here, but still trying to be
		# complete given never know what out-of-tree modules may use
		MODULES_MAKEARGS+=(
			# wrt bug #550428, given most toolchain variables are being passed to
			# make, setting CROSS in the environment would change very little
			# (instead set KERNEL_CHOST which will affect other variables,
			# or MODULES_I_WANT_FULL_CONTROL if do not want any of this)
			CROSS_COMPILE="${KERNEL_CHOST}-"

			HOSTCC="$(tc-getBUILD_CC)"
			HOSTCXX="$(tc-getBUILD_CXX)"

			# fwiw this function is not meant to pollute the environment
			HOSTCFLAGS="$(tc-export_build_env; echo "${BUILD_CFLAGS}")"
			HOSTCXXFLAGS="$(tc-export_build_env; echo "${BUILD_CXXFLAGS}")"
			HOSTLDFLAGS="$(tc-export_build_env; echo "${BUILD_LDFLAGS}")"

			HOSTPKG_CONFIG="$(tc-getBUILD_PKG_CONFIG)"

			CC="${KERNEL_CC}"
			CXX="${KERNEL_CXX}"
			LD="${KERNEL_LD}"
			AR="${KERNEL_AR}"
			NM="${KERNEL_NM}"
			OBJCOPY="${KERNEL_OBJCOPY}"
			OBJDUMP="${KERNEL_OBJDUMP}"
			READELF="${KERNEL_READELF}"
		)
	fi

	# eval is to handle quoted spaces, die is for syntax errors
	eval "MODULES_MAKEARGS+=( ${MODULES_EXTRA_EMAKE} )" || die
}

# @FUNCTION: _modules_update_depmod
# @INTERNAL
# @DESCRIPTION:
# If possible, update module dependencies using depmod and System.map,
# otherwise prompt user to handle it.  System.map may notably no longer
# be available on binary merges.
_modules_update_depmod() {
	# prefer /lib/modules' path given it is what depmod operates on,
	# and is mostly foolproof when it comes to ROOT (relative symlink)
	local map=${EROOT}/lib/modules/${KV_FULL}/build/System.map

	if [[ ! -f ${map} ]]; then
		# KV_OUT_DIR may still be right even on a different system, but state
		# of (E)ROOT is unknown, e.g. could be from KERNEL_DIR=${OLDROOT}/...
		map=${KV_OUT_DIR}/System.map

		# last resort, typical but may not be mounted/readable/installed
		[[ ! -f ${map} ]] &&
			map=${EROOT}/boot/System.map-${KV_FULL}
	fi

	einfo "Updating module dependencies for kernel ${KV_FULL} ..."
	if [[ -f ${map} ]]; then
		local depmodargs=( -ae -F "${map}" "${KV_FULL}" )

		# for nicer postinst display, keep command shorter if EROOT is unset
		[[ ${EROOT} ]] &&
			depmodargs+=(
				-b "${EROOT}"

				# EROOT from -b is not used when looking for configuration
				# directories, so pass the whole list from kmod's tools/depmod.c
				--config="${EROOT}"/{etc,run,{usr/{local/,},}lib}/depmod.d
			)

		nonfatal edob depmod "${depmodargs[@]}" && return 0
	else
		eerror
		eerror "System.map for kernel ${KV_FULL} was not found, may be due to the"
		eerror "built kernel sources no longer being available and lacking the fallback:"
		eerror
		eerror "${EROOT}/boot/System.map-${KV_FULL}"
	fi
	eerror
	eerror "Some modules may not load without updating manually using depmod."
}

fi

EXPORT_FUNCTIONS pkg_setup src_compile src_install pkg_postinst
