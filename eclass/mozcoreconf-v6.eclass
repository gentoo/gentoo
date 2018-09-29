# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#
# @ECLASS: mozcoreconf-v6.eclass
# @MAINTAINER:
# Mozilla team <mozilla@gentoo.org>
# @BLURB: core options and configuration functions for mozilla
# @DESCRIPTION:
#
# inherit mozconfig-v6.* or above for mozilla configuration support

# @ECLASS-VARIABLE: MOZILLA_FIVE_HOME
# @DESCRIPTION:
# This is an eclass-generated variable that defines the rpath that the mozilla
# product will be installed in.  Read-only

if [[ ! ${_MOZCORECONF} ]]; then

# for compatibility with packages prior to v1
if [[ -z ${PYTHON_COMPAT[@]} ]]; then
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='ncurses,sqlite,ssl,threads'
fi

inherit multilib toolchain-funcs flag-o-matic python-any-r1 versionator

IUSE="${IUSE} custom-cflags custom-optimization"

DEPEND="virtual/pkgconfig
	${PYTHON_DEPS}"

# @FUNCTION: mozconfig_annotate
# @DESCRIPTION:
# add an annotated line to .mozconfig
#
# Example:
# mozconfig_annotate "building on ultrasparc" --enable-js-ultrasparc
# => ac_add_options --enable-js-ultrasparc # building on ultrasparc
mozconfig_annotate() {
	declare reason=$1 x ; shift
	[[ $# -gt 0 ]] || die "mozconfig_annotate missing flags for ${reason}\!"
	for x in ${*}; do
		echo "ac_add_options ${x} # ${reason}" >>.mozconfig
	done
}

# @FUNCTION: mozconfig_use_enable
# @DESCRIPTION:
# add a line to .mozconfig based on a USE-flag
#
# Example:
# mozconfig_use_enable truetype freetype2
# => ac_add_options --enable-freetype2 # +truetype
mozconfig_use_enable() {
	declare flag=$(use_enable "$@")
	mozconfig_annotate "$(use $1 && echo +$1 || echo -$1)" "${flag}"
}

# @FUNCTION mozconfig_use_with
# @DESCRIPTION
# add a line to .mozconfig based on a USE-flag
#
# Example:
# mozconfig_use_with kerberos gss-api /usr/$(get_libdir)
# => ac_add_options --with-gss-api=/usr/lib # +kerberos
mozconfig_use_with() {
	declare flag=$(use_with "$@")
	mozconfig_annotate "$(use $1 && echo +$1 || echo -$1)" "${flag}"
}

# @FUNCTION mozconfig_use_extension
# @DESCRIPTION
# enable or disable an extension based on a USE-flag
#
# Example:
# mozconfig_use_extension gnome gnomevfs
# => ac_add_options --enable-extensions=gnomevfs
mozconfig_use_extension() {
	declare minus=$(use $1 || echo -)
	mozconfig_annotate "${minus:-+}$1" --enable-extensions=${minus}${2}
}

moz_pkgsetup() {
	# Ensure we use C locale when building
	export LANG="C"
	export LC_ALL="C"
	export LC_MESSAGES="C"
	export LC_CTYPE="C"

	# Ensure we use correct toolchain
	export HOST_CC="$(tc-getBUILD_CC)"
	export HOST_CXX="$(tc-getBUILD_CXX)"
	tc-export CC CXX LD PKG_CONFIG AR RANLIB

	# Ensure that we have a sane build enviroment
	export MOZILLA_CLIENT=1
	export BUILD_OPT=1
	export NO_STATIC_LIB=1
	export USE_PTHREADS=1
	export ALDFLAGS=${LDFLAGS}
	# ensure MOZCONFIG is not defined
	unset MOZCONFIG

	# set MOZILLA_FIVE_HOME
	export MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	# nested configure scripts in mozilla products generate unrecognized options
	# false positives when toplevel configure passes downwards.
	export QA_CONFIGURE_OPTIONS=".*"

	if [[ $(gcc-major-version) -eq 3 ]]; then
		ewarn "Unsupported compiler detected, DO NOT file bugs for"
		ewarn "outdated compilers. Bugs opened with gcc-3 will be closed"
		ewarn "invalid."
	fi

	python-any-r1_pkg_setup
	# workaround to set python3 into PYTHON3 until mozilla doesn't need py2
	if [[ "${PYTHON_COMPAT[@]}" != "${PYTHON_COMPAT[@]#python3*}" ]]; then
		export PYTHON3=${PYTHON}
		python_export python2_7 PYTHON EPYTHON
	fi
}

# @FUNCTION: mozconfig_init
# @DESCRIPTION:
# Initialize mozilla configuration and populate with core settings.
# This should be called in src_configure before any other mozconfig_* functions.
mozconfig_init() {
	declare enable_optimize pango_version myext x
	declare XUL=$([[ ${PN} == xulrunner ]] && echo true || echo false)
	declare FF=$([[ ${PN} == firefox ]] && echo true || echo false)
	declare SM=$([[ ${PN} == seamonkey ]] && echo true || echo false)
	declare TB=$([[ ${PN} == thunderbird ]] && echo true || echo false)
	declare TRB=$([[ ${PN} == torbrowser ]] && echo true || echo false)

	####################################
	#
	# Setup the initial .mozconfig
	# See http://www.mozilla.org/build/configure-build.html
	#
	####################################

	case ${PN} in
		*xulrunner)
			cp xulrunner/config/mozconfig .mozconfig \
				|| die "cp xulrunner/config/mozconfig failed" ;;
		*firefox)
			cp browser/config/mozconfig .mozconfig \
				|| die "cp browser/config/mozconfig failed" ;;
		*torbrowser)
			cp browser/config/mozconfig .mozconfig \
				|| die "cp browser/config/mozconfig failed" ;;
		seamonkey)
			# Must create the initial mozconfig to enable application
			: >.mozconfig || die "initial mozconfig creation failed"
			# NOTE--this is not compatible with mozilla prior to v60
			mozconfig_annotate "" --enable-application=comm/suite ;;
		*thunderbird)
			# Must create the initial mozconfig to enable application
			: >.mozconfig || die "initial mozconfig creation failed"
			# NOTE--this is not compatible with mozilla prior to v60
			mozconfig_annotate "" --enable-application=comm/mail ;;
	esac

	####################################
	#
	# CFLAGS setup and ARCH support
	#
	####################################

	# Set optimization level
	if [[ $(gcc-major-version) -eq 7 ]]; then
		mozconfig_annotate "Workaround known breakage" --enable-optimize=-O2
	elif [[ ${ARCH} == hppa ]]; then
		mozconfig_annotate "more than -O0 causes a segfault on hppa" --enable-optimize=-O0
	elif [[ ${ARCH} == x86 ]]; then
		mozconfig_annotate "less than -O2 causes a segfault on x86" --enable-optimize=-O2
	elif [[ ${ARCH} == arm ]] && [[ $(gcc-major-version) -ge 6 ]]; then
		mozconfig_annotate "less than -O2 causes a breakage on arm with gcc-6" --enable-optimize=-O2
	elif use custom-optimization || [[ ${ARCH} =~ (alpha|ia64) ]]; then
		# Set optimization level based on CFLAGS
		if is-flag -O0; then
			mozconfig_annotate "from CFLAGS" --enable-optimize=-O0
		elif [[ ${ARCH} == ppc ]] && has_version '>=sys-libs/glibc-2.8'; then
			mozconfig_annotate "more than -O1 segfaults on ppc with glibc-2.8" --enable-optimize=-O1
		elif is-flag -O4; then
			mozconfig_annotate "from CFLAGS" --enable-optimize=-O4
		elif is-flag -O3; then
			mozconfig_annotate "from CFLAGS" --enable-optimize=-O3
		elif is-flag -O1; then
			mozconfig_annotate "from CFLAGS" --enable-optimize=-O1
		elif is-flag -Os; then
			mozconfig_annotate "from CFLAGS" --enable-optimize=-Os
		else
			mozconfig_annotate "Gentoo's default optimization" --enable-optimize=-O2
		fi
	else
		# Enable Mozilla's default
		mozconfig_annotate "mozilla default" --enable-optimize
	fi

	# Strip optimization so it does not end up in compile string
	filter-flags '-O*'

	# Strip over-aggressive CFLAGS
	use custom-cflags || strip-flags

	# Additional ARCH support
	case "${ARCH}" in
	arm)
		# Reduce the memory requirements for linking
		if tc-ld-is-gold
		append-ldflags -Wl,--no-keep-memory
		fi
		;;
	alpha)
		# Historically we have needed to add -fPIC manually for 64-bit.
		# Additionally, alpha should *always* build with -mieee for correct math
		# operation
		append-flags -fPIC -mieee
		;;
	ia64)
		# Historically we have needed to add this manually for 64-bit
		append-flags -fPIC
		;;
	ppc64)
		append-flags -fPIC -mminimal-toc
		# Reduce the memory requirements for linking
		append-ldflags -Wl,--no-keep-memory -Wl,--reduce-memory-overheads
		;;
	esac

	# We need to append flags for gcc-6 support
	if [[ $(gcc-major-version) -ge 6 ]]; then
		append-cxxflags -fno-delete-null-pointer-checks -fno-lifetime-dse -fno-schedule-insns -fno-schedule-insns2
	fi

	# Use the MOZILLA_FIVE_HOME for the rpath
	append-ldflags -Wl,-rpath="${MOZILLA_FIVE_HOME}",--enable-new-dtags

	####################################
	#
	# mozconfig setup
	#
	####################################

	mozconfig_annotate disable_update_strip \
		--disable-updater \
		--disable-strip \
		--disable-install-strip

	# jemalloc won't build with older glibc
	! has_version ">=sys-libs/glibc-2.4" && mozconfig_annotate "we have old glibc" --disable-jemalloc
}

# @FUNCTION: mozconfig_final
# @DESCRIPTION:
# Apply EXTRA_ECONF values to .mozconfig
# Display a table describing all configuration options paired
# with reasons, then clean up extensions list.
# This should be called in src_configure at the end of all other mozconfig_* functions.
mozconfig_final() {
	declare ac opt hash reason

	# Apply EXTRA_ECONF entries to .mozconfig
	if [[ -n ${EXTRA_ECONF} ]]; then
		IFS=\! read -a ac <<<${EXTRA_ECONF// --/\!}
		for opt in "${ac[@]}"; do
			mozconfig_annotate "EXTRA_ECONF" --${opt#--}
		done
	fi

	echo
	echo "=========================================================="
	echo "Building ${PF} with the following configuration"
	grep ^ac_add_options .mozconfig | while read ac opt hash reason; do
		[[ -z ${hash} || ${hash} == \# ]] \
			|| die "error reading mozconfig: ${ac} ${opt} ${hash} ${reason}"
		printf "    %-30s  %s\n" "${opt}" "${reason:-mozilla.org default}"
	done
	echo "=========================================================="
	echo

	# Resolve multiple --enable-extensions down to one
	declare exts=$(sed -n 's/^ac_add_options --enable-extensions=\([^ ]*\).*/\1/p' \
		.mozconfig | xargs)
	sed -i '/^ac_add_options --enable-extensions/d' .mozconfig
	echo "ac_add_options --enable-extensions=${exts// /,}" >> .mozconfig
}

_MOZCORECONF=1
fi
