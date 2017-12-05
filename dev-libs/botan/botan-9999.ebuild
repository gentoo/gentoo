# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit multilib python-r1 toolchain-funcs
inherit git-r3

DESCRIPTION="A C++ crypto library"
HOMEPAGE="http://botan.randombit.net/"
EGIT_REPO_URI="https://github.com/randombit/botan"

KEYWORDS=""
SLOT="2/3" # soname version
LICENSE="BSD"
IUSE="bindist doc boost python bzip2 libressl lzma sqlite ssl static-libs zlib"

RDEPEND="bzip2? ( >=app-arch/bzip2-1.0.5 )
	zlib? ( >=sys-libs/zlib-1.2.3 )
	boost? ( >=dev-libs/boost-1.48 )
	lzma? ( app-arch/xz-utils )
	sqlite? ( dev-db/sqlite:3 )
	ssl? (
		!libressl? ( dev-libs/openssl:0=[bindist=] )
		libressl? ( dev-libs/libressl:0= )
	)"
DEPEND="${RDEPEND}
	dev-lang/python:*
	doc? ( dev-python/sphinx )"

src_prepare() {
	default
	use python && python_copy_sources
}

src_configure() {
	local disable_modules=()
	use boost || disable_modules+=( "boost" )
	use bindist && disable_modules+=( "ecdsa" )
	elog "Disabling modules: ${disable_modules[@]}"

	# Enable v9 instructions for sparc64
	if [[ "${PROFILE_ARCH}" = "sparc64" ]]; then
		CHOSTARCH="sparc32-v9"
	else
		CHOSTARCH="${CHOST%%-*}"
	fi

	local myos=
	case ${CHOST} in
		*-darwin*)   myos=darwin ;;
		*)           myos=linux  ;;
	esac

	local pythonvers=()
	if use python; then
		append() {
			pythonvers+=( ${EPYTHON/python/} )
		}
		python_foreach_impl append
	fi

	CXX="$(tc-getCXX)" AR="$(tc-getAR)" ./configure.py \
		--prefix="${EPREFIX}/usr" \
		--libdir=$(get_libdir) \
		--docdir=share/doc \
		--cc=gcc \
		--os=${myos} \
		--cpu=${CHOSTARCH} \
		--with-endian="$(tc-endian)" \
		--without-doxygen \
		$(use_with bzip2) \
		$(use_with lzma) \
		$(use_with sqlite sqlite3) \
		$(use_with ssl openssl) \
		$(use_with zlib) \
		$(use_with boost) \
		$(use_with doc sphinx) \
		$(use_with doc documentation) \
		$(use_enable static-libs static-library) \
		--with-python-version=$(IFS=","; echo "${pythonvers[*]}" ) \
		--disable-modules=$(IFS=","; echo "${disable_modules[*]}" ) \
		|| die "configure.py failed"
}

src_test() {
	LD_LIBRARY_PATH="${S}" ./botan-test || die "Validation tests failed"
}

src_install() {
	default
	use python && python_foreach_impl python_optimize
}
