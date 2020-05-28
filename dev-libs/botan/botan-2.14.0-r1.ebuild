# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

MY_P="Botan-${PV}"
inherit python-r1 toolchain-funcs

DESCRIPTION="C++ crypto library"
HOMEPAGE="https://botan.randombit.net/"
SRC_URI="https://botan.randombit.net/releases/${MY_P}.tar.xz"

LICENSE="BSD"
SLOT="2/$(ver_cut 1-2)" # soname version
KEYWORDS="amd64 ~arm ~hppa ~ia64 ppc ppc64 ~sparc x86 ~ppc-macos"
IUSE="bindist bzip2 boost doc libressl lzma python sqlite ssl static-libs zlib"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MY_P}"

DEPEND="python? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}
	boost? ( >=dev-libs/boost-1.48:= )
	bzip2? ( >=app-arch/bzip2-1.0.5:= )
	lzma? ( app-arch/xz-utils:= )
	sqlite? ( dev-db/sqlite:3= )
	ssl? (
		!libressl? ( dev-libs/openssl:0=[bindist=] )
		libressl? ( dev-libs/libressl:0= )
	)
	zlib? ( >=sys-libs/zlib-1.2.3:= )
"
BDEPEND="
	dev-lang/python:*
	doc? ( dev-python/sphinx )
"

PATCHES=(
	"${FILESDIR}/${P}-bindist-test-fix.patch"
)

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
		*-darwin*) myos=darwin ;;
		*) myos=linux  ;;
	esac

	case ${CHOST} in
		hppa*) CHOSTARCH=parisc ;;
	esac

	local pythonvers=()
	if use python; then
		append() {
			pythonvers+=( ${EPYTHON/python/} )
		}
		python_foreach_impl append
	fi

	# Don't install automatically, do it manually later in right place
	# https://bugs.gentoo.org/723096
	CXX="$(tc-getCXX)" AR="$(tc-getAR)" ./configure.py \
		$(use_enable static-libs static-library) \
		$(use_with boost) \
		$(use_with bzip2) \
		$(use_with doc documentation) \
		$(use_with doc sphinx) \
		$(use_with lzma) \
		$(use_with sqlite sqlite3) \
		$(use_with ssl openssl) \
		$(use_with zlib) \
		$(usex hppa --without-stack-protector '') \
		--cc=gcc \
		--cpu=${CHOSTARCH} \
		--disable-modules=$(IFS=","; echo "${disable_modules[*]}" ) \
		--docdir=share/doc \
		--libdir=$(get_libdir) \
		--os=${myos} \
		--distribution-info="Gentoo ${PVR}" \
		--prefix="${EPREFIX}/usr" \
		--with-endian="$(tc-endian)" \
		--with-python-version=$(IFS=","; echo "${pythonvers[*]}" ) \
		--without-doxygen \
		--no-install-python-module \
		|| die "configure.py failed"
}

src_test() {
	LD_LIBRARY_PATH="${S}" ./botan-test || die "Validation tests failed"
}

src_install() {
	default
	use python && python_foreach_impl python_domodule src/python/botan2.py
}
