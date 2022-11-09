# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic

DESCRIPTION="Console-mode amateur radio contest logger"
HOMEPAGE="http://home.iae.nl/users/reinc/TLF-0.2.html"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="sys-libs/ncurses:=
	dev-libs/glib:2
	media-libs/hamlib:=
	media-sound/sox
	dev-libs/xmlrpc-c[curl]
	elibc_musl? ( sys-libs/argp-standalone )"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cmocka )"

PATCHES=( "${FILESDIR}/${P}-zone_nr.patch"
	  "${FILESDIR}/${P}-musl.patch"
	  "${FILESDIR}/${P}-missing-include.patch"
	)

src_prepare() {
	if has_version '>=media-libs/hamlib-4.2' ; then
		sed -i -e "s/FILPATHLEN/HAMLIB_FILPATHLEN/g" "${S}"/src/sendqrg.c || die
	fi

	eapply ${PATCHES[@]}
	eapply_user
}

src_configure() {
	use elibc_musl && append-libs argp
	append-ldflags -L/usr/$(get_libdir)/hamlib
	filter-lto		# bug # 876418
	econf --enable-fldigi-xmlrpc
}
