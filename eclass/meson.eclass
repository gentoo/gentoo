# Copyright 2017-2018 Gentoo Authors
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
# 		-Dqt4=$(usex qt4 true false)
# 		-Dthreads=$(usex threads true false)
# 		-Dtiff=$(usex tiff true false)
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

if [[ ${__MESON_AUTO_DEPEND+set} == "set" ]] ; then
	# See if we were included already, but someone changed the value
	# of MESON_AUTO_DEPEND on us.  We could reload the entire
	# eclass at that point, but that adds overhead, and it's trivial
	# to re-order inherit in eclasses/ebuilds instead.  #409611
	if [[ ${__MESON_AUTO_DEPEND} != ${MESON_AUTO_DEPEND} ]] ; then
		die "MESON_AUTO_DEPEND changed value between inherits; please inherit meson.eclass first! ${__MESON_AUTO_DEPEND} -> ${MESON_AUTO_DEPEND}"
	fi
fi

if [[ -z ${_MESON_ECLASS} ]]; then

inherit ninja-utils python-utils-r1 toolchain-funcs

fi

EXPORT_FUNCTIONS src_configure src_compile src_test src_install

if [[ -z ${_MESON_ECLASS} ]]; then
_MESON_ECLASS=1

MESON_DEPEND=">=dev-util/meson-0.45.1
	>=dev-util/ninja-1.7.2"

# @ECLASS-VARIABLE: MESON_AUTO_DEPEND
# @DESCRIPTION:
# Set to 'no' to disable automatically adding to DEPEND.  This lets
# ebuilds form conditional depends by using ${MESON_DEPEND} in
# their own DEPEND string.
: ${MESON_AUTO_DEPEND:=yes}
if [[ ${MESON_AUTO_DEPEND} != "no" ]] ; then
	if [[ ${EAPI:-0} == [0123456] ]]; then
		DEPEND=${MESON_DEPEND}
	else
		BDEPEND=${MESON_DEPEND}
	fi
fi
__MESON_AUTO_DEPEND=${MESON_AUTO_DEPEND} # See top of eclass

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

# @FUNCTION: _meson_create_cross_file
# @INTERNAL
# @DESCRIPTION:
# Creates a cross file. meson uses this to define settings for
# cross-compilers. This function is called from meson_src_configure.
_meson_create_cross_file() {
	# Reference: http://mesonbuild.com/Cross-compilation.html

	# system roughly corresponds to uname -s (lowercase)
	local system=unknown
	case ${CHOST} in
		*-aix*)          system=aix ;;
		*-cygwin*)       system=cygwin ;;
		*-darwin*)       system=darwin ;;
		*-freebsd*)      system=freebsd ;;
		*-linux*)        system=linux ;;
		mingw*|*-mingw*) system=windows ;;
		*-solaris*)      system=sunos ;;
	esac

	local cpu_family=$(tc-arch)
	case ${cpu_family} in
		amd64) cpu_family=x86_64 ;;
		arm64) cpu_family=aarch64 ;;
	esac

	# This may require adjustment based on CFLAGS
	local cpu=${CHOST%%-*}

	cat > "${T}/meson.${CHOST}.${ABI}" <<-EOF
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

	[host_machine]
	system = '${system}'
	cpu_family = '${cpu_family}'
	cpu = '${cpu}'
	endian = '$(tc-endian)'
	EOF
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

# @FUNCTION: meson_src_configure
# @DESCRIPTION:
# This is the meson_src_configure function.
meson_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	# Common args
	local mesonargs=(
		--buildtype plain
		--libdir "$(get_libdir)"
		--localstatedir "${EPREFIX}/var/lib"
		--prefix "${EPREFIX}/usr"
		--sysconfdir "${EPREFIX}/etc"
		--wrap-mode nodownload
		)

	if tc-is-cross-compiler || [[ ${ABI} != ${DEFAULT_ABI-${ABI}} ]]; then
		_meson_create_cross_file || die "unable to write meson cross file"
		mesonargs+=( --cross-file "${T}/meson.${CHOST}.${ABI}" )
	fi

	# https://bugs.gentoo.org/625396
	python_export_utf8_locale

	# Append additional arguments from ebuild
	mesonargs+=("${emesonargs[@]}")

	BUILD_DIR="${BUILD_DIR:-${WORKDIR}/${P}-build}"
	set -- meson "${mesonargs[@]}" "$@" \
		"${EMESON_SOURCE:-${S}}" "${BUILD_DIR}"
	echo "$@"
	tc-env_build "$@" || die
}

# @FUNCTION: meson_src_compile
# @DESCRIPTION:
# This is the meson_src_compile function.
meson_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	eninja -C "${BUILD_DIR}"
}

# @FUNCTION: meson_src_test
# @DESCRIPTION:
# This is the meson_src_test function.
meson_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	eninja -C "${BUILD_DIR}" test
}

# @FUNCTION: meson_src_install
# @DESCRIPTION:
# This is the meson_src_install function.
meson_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	DESTDIR="${D}" eninja -C "${BUILD_DIR}" install
	einstalldocs
}

fi
