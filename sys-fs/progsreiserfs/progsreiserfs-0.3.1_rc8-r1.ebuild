# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic libtool

MY_P=${PN}-${PV/_/-}

DESCRIPTION="Library for accessing and manipulating reiserfs partitions"
HOMEPAGE="http://reiserfs.linux.kiev.ua/"
SRC_URI="http://reiserfs.linux.kiev.ua/snapshots/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ~ppc64 ~riscv ~sparc x86"
IUSE="debug examples nls static-libs"

DEPEND="
	sys-apps/util-linux
	nls? (
		sys-devel/gettext
		virtual/libintl
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${PN}-0.3.1_rc8-musl-getopt_internal-fix.patch
	"${FILESDIR}"/${PN}-0.3.1_rc8-c99-configure.patch
)

src_prepare() {
	default

	elibtoolize
}

src_configure() {
	filter-lfs-flags

	econf \
		$(use_enable static-libs static) \
		--disable-Werror \
		$(use_enable nls) \
		$(use_enable debug)
}

src_install() {
	default

	if use examples; then
		docinto examples
		dodoc demos/*.c
	fi

	find "${ED}" -name '*.la' -delete || die

	rm -r "${ED}"/usr/{sbin,share/man} || die
}

pkg_postinst() {
	ewarn "progsreiserfs has been proven dangerous in the past, generating bad"
	ewarn "partitions and destroying data on resize/cpfs operations."
	ewarn "Because of this, we do NOT provide their binaries, but only their"
	ewarn "libraries instead, as these are needed for other applications."
}
