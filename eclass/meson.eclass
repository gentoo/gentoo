# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: meson.eclass
# @MAINTAINER:
# William Hubbs <williamh@gentoo.org>
# Mike Gilbert <floppym@gentoo.org>
# @SUPPORTED_EAPIS: 6 7
# @BLURB: common ebuild functions for meson-based packages
# @DESCRIPTION:
# This eclass contains the default phase functions for packages which
# use the meson build system.
#
# @EXAMPLE:
# Typical ebuild using meson.eclass:
#
# @CODE
# EAPI=6
#
# inherit meson
#
# ...
#
# src_configure() {
# 	local emesonargs=(
# 		$(meson_use qt4)
# 		$(meson_feature threads)
# 		$(meson_use bindist official_branding)
# 	)
# 	meson_src_configure
# }
#
# ...
#
# @CODE

case ${EAPI:-0} in
	6|7) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

if [[ -z ${_MESON_ECLASS} ]]; then

inherit multiprocessing ninja-utils python-utils-r1 toolchain-funcs

fi

EXPORT_FUNCTIONS src_configure src_compile src_test src_install

if [[ -z ${_MESON_ECLASS} ]]; then
_MESON_ECLASS=1

MESON_DEPEND=">=dev-util/meson-0.51.2
	>=dev-util/ninja-1.8.2"

if [[ ${EAPI:-0} == [6] ]]; then
	DEPEND=${MESON_DEPEND}
else
	BDEPEND=${MESON_DEPEND}
fi

# @ECLASS-VARIABLE: BUILD_DIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# Build directory, location where all generated files should be placed.
# If this isn't set, it defaults to ${WORKDIR}/${P}-build.

# @ECLASS-VARIABLE: EMESON_SOURCE
# @DEFAULT_UNSET
# @DESCRIPTION:
# The location of the source files for the project; this is the source
# directory to pass to meson.
# If this isn't set, it defaults to ${S}

# @VARIABLE: emesonargs
# @DEFAULT_UNSET
# @DESCRIPTION:
# Optional meson arguments as Bash array; this should be defined before
# calling meson_src_configure.

# @VARIABLE: emesontestargs
# @DEFAULT_UNSET
# @DESCRIPTION:
# Optional meson test arguments as Bash array; this should be defined before
# calling meson_src_test.

# @VARIABLE: MYMESONARGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# User-controlled environment variable containing arguments to be passed to
# meson in meson_src_configure.

read -d '' __MESON_ARRAY_PARSER <<"EOF"
import shlex
import sys

# See http://mesonbuild.com/Syntax.html#strings
def quote(str):
	escaped = str.replace("\\\\", "\\\\\\\\").replace("'", "\\\\'")
	return "'{}'".format(escaped)

print("[{}]".format(
	", ".join([quote(x) for x in shlex.split(" ".join(sys.argv[1:]))])))
EOF

# @FUNCTION: _meson_env_array
# @INTERNAL
# @DESCRIPTION:
# Parses the command line flags and converts them into an array suitable for
# use in a cross file.
#
# Input: --single-quote=\' --double-quote=\" --dollar=\$ --backtick=\`
#        --backslash=\\ --full-word-double="Hello World"
#        --full-word-single='Hello World'
#        --full-word-backslash=Hello\ World
#        --simple --unicode-8=© --unicode-16=𐐷 --unicode-32=𐤅
#
# Output: ['--single-quote=\'', '--double-quote="', '--dollar=$',
#          '--backtick=`', '--backslash=\\', '--full-word-double=Hello World',
#          '--full-word-single=Hello World',
#          '--full-word-backslash=Hello World', '--simple', '--unicode-8=©',
#          '--unicode-16=𐐷', '--unicode-32=𐤅']
#
_meson_env_array() {
	python -c "${__MESON_ARRAY_PARSER}" "$@"
}

# @FUNCTION: _meson_get_machine_info
# @USAGE: <tuple>
# @RETURN: system/cpu_family/cpu variables
# @INTERNAL
# @DESCRIPTION:
# Translate toolchain tuple into machine values for meson.
_meson_get_machine_info() {
	local tuple=$1

	# system roughly corresponds to uname -s (lowercase)
	case ${tuple} in
		*-aix*)          system=aix ;;
		*-cygwin*)       system=cygwin ;;
		*-darwin*)       system=darwin ;;
		*-freebsd*)      system=freebsd ;;
		*-linux*)        system=linux ;;
		mingw*|*-mingw*) system=windows ;;
		*-solaris*)      system=sunos ;;
	esac

	cpu_family=$(tc-arch "${tuple}")
	case ${cpu_family} in
		amd64) cpu_family=x86_64 ;;
		arm64) cpu_family=aarch64 ;;
	esac

	# This may require adjustment based on CFLAGS
	cpu=${tuple%%-*}
}

# @FUNCTION: _meson_create_cross_file
# @RETURN: path to cross file
# @INTERNAL
# @DESCRIPTION:
# Creates a cross file. meson uses this to define settings for
# cross-compilers. This function is called from meson_src_configure.
_meson_create_cross_file() {
	local system cpu_family cpu
	_meson_get_machine_info "${CHOST}"

	local fn=${T}/meson.${CHOST}.${ABI}.ini

	cat > "${fn}" <<-EOF
	[binaries]
	ar = $(_meson_env_array "$(tc-getAR)")
	c = $(_meson_env_array "$(tc-getCC)")
	cpp = $(_meson_env_array "$(tc-getCXX)")
	fortran = $(_meson_env_array "$(tc-getFC)")
	llvm-config = '$(tc-getPROG LLVM_CONFIG llvm-config)'
	objc = $(_meson_env_array "$(tc-getPROG OBJC cc)")
	objcpp = $(_meson_env_array "$(tc-getPROG OBJCXX c++)")
	pkgconfig = '$(tc-getPKG_CONFIG)'
	strip = $(_meson_env_array "$(tc-getSTRIP)")
	windres = $(_meson_env_array "$(tc-getRC)")

	[properties]
	c_args = $(_meson_env_array "${CFLAGS} ${CPPFLAGS}")
	c_link_args = $(_meson_env_array "${CFLAGS} ${LDFLAGS}")
	cpp_args = $(_meson_env_array "${CXXFLAGS} ${CPPFLAGS}")
	cpp_link_args = $(_meson_env_array "${CXXFLAGS} ${LDFLAGS}")
	fortran_args = $(_meson_env_array "${FCFLAGS}")
	fortran_link_args = $(_meson_env_array "${FCFLAGS} ${LDFLAGS}")
	objc_args = $(_meson_env_array "${OBJCFLAGS} ${CPPFLAGS}")
	objc_link_args = $(_meson_env_array "${OBJCFLAGS} ${LDFLAGS}")
	objcpp_args = $(_meson_env_array "${OBJCXXFLAGS} ${CPPFLAGS}")
	objcpp_link_args = $(_meson_env_array "${OBJCXXFLAGS} ${LDFLAGS}")
	needs_exe_wrapper = true
	sys_root = '${SYSROOT}'
	pkg_config_libdir = '${EPREFIX}/usr/$(get_libdir)/pkgconfig'

	[host_machine]
	system = '${system}'
	cpu_family = '${cpu_family}'
	cpu = '${cpu}'
	endian = '$(tc-endian "${CHOST}")'
	EOF

	echo "${fn}"
}

# @FUNCTION: _meson_create_native_file
# @RETURN: path to native file
# @INTERNAL
# @DESCRIPTION:
# Creates a native file. meson uses this to define settings for
# native compilers. This function is called from meson_src_configure.
_meson_create_native_file() {
	local system cpu_family cpu
	_meson_get_machine_info "${CBUILD}"

	local fn=${T}/meson.${CBUILD}.${ABI}.ini

	cat > "${fn}" <<-EOF
	[binaries]
	ar = $(_meson_env_array "$(tc-getBUILD_AR)")
	c = $(_meson_env_array "$(tc-getBUILD_CC)")
	cpp = $(_meson_env_array "$(tc-getBUILD_CXX)")
	fortran = $(_meson_env_array "$(tc-getBUILD_PROG FC gfortran)")
	llvm-config = '$(tc-getBUILD_PROG LLVM_CONFIG llvm-config)'
	objc = $(_meson_env_array "$(tc-getBUILD_PROG OBJC cc)")
	objcpp = $(_meson_env_array "$(tc-getBUILD_PROG OBJCXX c++)")
	pkgconfig = '$(tc-getBUILD_PKG_CONFIG)'
	strip = $(_meson_env_array "$(tc-getBUILD_STRIP)")
	windres = $(_meson_env_array "$(tc-getBUILD_PROG RC windres)")

	[properties]
	c_args = $(_meson_env_array "${BUILD_CFLAGS} ${BUILD_CPPFLAGS}")
	c_link_args = $(_meson_env_array "${BUILD_CFLAGS} ${BUILD_LDFLAGS}")
	cpp_args = $(_meson_env_array "${BUILD_CXXFLAGS} ${BUILD_CPPFLAGS}")
	cpp_link_args = $(_meson_env_array "${BUILD_CXXFLAGS} ${BUILD_LDFLAGS}")
	fortran_args = $(_meson_env_array "${BUILD_FCFLAGS}")
	fortran_link_args = $(_meson_env_array "${BUILD_FCFLAGS} ${BUILD_LDFLAGS}")
	objc_args = $(_meson_env_array "${BUILD_OBJCFLAGS} ${BUILD_CPPFLAGS}")
	objc_link_args = $(_meson_env_array "${BUILD_OBJCFLAGS} ${BUILD_LDFLAGS}")
	objcpp_args = $(_meson_env_array "${BUILD_OBJCXXFLAGS} ${BUILD_CPPFLAGS}")
	objcpp_link_args = $(_meson_env_array "${BUILD_OBJCXXFLAGS} ${BUILD_LDFLAGS}")
	needs_exe_wrapper = false
	pkg_config_libdir = '${EPREFIX}/usr/$(get_libdir)/pkgconfig'

	[build_machine]
	system = '${system}'
	cpu_family = '${cpu_family}'
	cpu = '${cpu}'
	endian = '$(tc-endian "${CBUILD}")'
	EOF

	echo "${fn}"
}

# @FUNCTION: meson_use
# @USAGE: <USE flag> [option name]
# @DESCRIPTION:
# Given a USE flag and meson project option, outputs a string like:
#
#   -Doption=true
#   -Doption=false
#
# If the project option is unspecified, it defaults to the USE flag.
meson_use() {
	usex "$1" "-D${2-$1}=true" "-D${2-$1}=false"
}

# @FUNCTION: meson_feature
# @USAGE: <USE flag> [option name]
# @DESCRIPTION:
# Given a USE flag and meson project option, outputs a string like:
#
#   -Doption=enabled
#   -Doption=disabled
#
# If the project option is unspecified, it defaults to the USE flag.
meson_feature() {
	usex "$1" "-D${2-$1}=enabled" "-D${2-$1}=disabled"
}

# @FUNCTION: meson_src_configure
# @USAGE: [extra meson arguments]
# @DESCRIPTION:
# This is the meson_src_configure function.
meson_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	tc-export_build_env
	: ${BUILD_FCFLAGS:=${FCFLAGS}}
	: ${BUILD_OBJCFLAGS:=${OBJCFLAGS}}
	: ${BUILD_OBJCXXFLAGS:=${OBJCXXFLAGS}}

	local mesonargs=(
		meson setup
		--buildtype plain
		--libdir "$(get_libdir)"
		--localstatedir "${EPREFIX}/var/lib"
		--prefix "${EPREFIX}/usr"
		--sysconfdir "${EPREFIX}/etc"
		--wrap-mode nodownload
		--build.pkg-config-path="${EPREFIX}/usr/share/pkgconfig"
		--pkg-config-path="${EPREFIX}/usr/share/pkgconfig"
		--native-file "$(_meson_create_native_file)"
	)

	if tc-is-cross-compiler; then
		mesonargs+=( --cross-file "$(_meson_create_cross_file)" )
	fi

	BUILD_DIR="${BUILD_DIR:-${WORKDIR}/${P}-build}"

	# Handle quoted whitespace
	eval "local -a MYMESONARGS=( ${MYMESONARGS} )"

	mesonargs+=(
		# Arguments from ebuild
		"${emesonargs[@]}"

		# Arguments passed to this function
		"$@"

		# Arguments from user
		"${MYMESONARGS[@]}"

		# Source directory
		"${EMESON_SOURCE:-${S}}"

		# Build directory
		"${BUILD_DIR}"
	)

	# Used by symbolextractor.py
	# https://bugs.gentoo.org/717720
	tc-export NM
	tc-getPROG READELF readelf >/dev/null

	# https://bugs.gentoo.org/625396
	python_export_utf8_locale

	echo "${mesonargs[@]}" >&2
	"${mesonargs[@]}" || die
}

# @FUNCTION: meson_src_compile
# @USAGE: [extra ninja arguments]
# @DESCRIPTION:
# This is the meson_src_compile function.
meson_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	eninja -C "${BUILD_DIR}" "$@"
}

# @FUNCTION: meson_src_test
# @USAGE: [extra meson test arguments]
# @DESCRIPTION:
# This is the meson_src_test function.
meson_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	local mesontestargs=(
		-C "${BUILD_DIR}"
	)
	[[ -n ${NINJAOPTS} || -n ${MAKEOPTS} ]] &&
		mesontestargs+=(
			--num-processes "$(makeopts_jobs ${NINJAOPTS:-${MAKEOPTS}})"
		)

	# Append additional arguments from ebuild
	mesontestargs+=("${emesontestargs[@]}")

	set -- meson test "${mesontestargs[@]}" "$@"
	echo "$@" >&2
	"$@" || die "tests failed"
}

# @FUNCTION: meson_src_install
# @USAGE: [extra ninja install arguments]
# @DESCRIPTION:
# This is the meson_src_install function.
meson_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	DESTDIR="${D}" eninja -C "${BUILD_DIR}" install "$@"
	einstalldocs
}

fi
