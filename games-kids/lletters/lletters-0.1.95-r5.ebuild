# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Game that helps young kids learn their letters and numbers"
HOMEPAGE="https://lln.sourceforge.net/"
SRC_URI="
	mirror://gentoo/${PN}_${PV}+gtk2.orig.tar.gz
	mirror://gentoo/${PN}_${PV}+gtk2-3.diff.gz
	mirror://sourceforge/lln/${PN}-media-0.1.9a.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	x11-libs/gtk+:2
	dev-libs/glib:2
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${WORKDIR}/${PN}_${PV}+gtk2-3.diff"
	"${FILESDIR}/${P}-build-2.patch"
	"${FILESDIR}/${P}-underlink.patch"
	"${FILESDIR}/${P}-make-382.patch"
	"${FILESDIR}/${P}-fno-common.patch"
	"${FILESDIR}/${P}-nolang.patch"
	"${FILESDIR}/${P}-clang16.patch"
)

src_prepare() {
	default

	cp -r "${WORKDIR}"/{images,sounds} . || die
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default

	newdoc debian/changelog ChangeLog.debian

	doicon debian/${PN}.xpm
	make_desktop_entry ${PN} "Linux Letters and Numbers"
}
