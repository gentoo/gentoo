# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs multilib-minimal

DESCRIPTION="Console utility and library for computing and verifying file hash sums"
HOMEPAGE="http://rhash.anz.ru/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug nls openssl static-libs"

RDEPEND="openssl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/librhash-symlink.patch
)

src_prepare() {
	default

	# Exit on test failure or src_test will always succeed.
	sed -i "s/return 1/exit 1/g" tests/test_rhash.sh || die

	multilib_copy_sources
}

multilib_src_compile() {
	local ADDCFLAGS=(
		$(use debug || echo -DNDEBUG)
		$(use nls && echo -DUSE_GETTEXT)
		$(use openssl && echo -DOPENSSL_RUNTIME -rdynamic)
	)

	local ADDLDFLAGS=(
		$(use openssl && echo -ldl)
	)

	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)" \
		  ADDCFLAGS="${ADDCFLAGS[*]}" ADDLDFLAGS="${ADDLDFLAGS[*]}" \
		  $(multilib_is_native_abi && echo build-shared || echo lib-shared) \
		  $(use static-libs && echo lib-static)
}

myemake() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr LIBDIR='$(PREFIX)'/$(get_libdir) "${@}"
}

multilib_src_install() {
	myemake install-lib-shared
	multilib_is_native_abi && myemake install-shared
	use static-libs && myemake install-lib-static
}

multilib_src_install_all() {
	myemake -C librhash install-headers
	use nls && myemake install-gmo
	einstalldocs
}

multilib_src_test() {
	cd tests || die
	./test_rhash.sh --full ../rhash_shared || die "tests failed"
}
