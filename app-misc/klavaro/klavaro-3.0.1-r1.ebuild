# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P="${PN}-$(ver_rs 2 '')"
DESCRIPTION="Another free touch typing tutor program"
HOMEPAGE="http://klavaro.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${MY_P}.tar.bz2"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="
	dev-util/intltool
	dev-util/gtk-builder-convert
	>=sys-devel/gettext-0.18.3
"
RDEPEND="
	net-misc/curl
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/pango
"
# gtk+3 version needed
#	x11-libs/gtkdatabox

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-out-of-source.patch
	"${FILESDIR}"/${P}-static.patch
	"${FILESDIR}"/${P}-datadir.patch
	"${FILESDIR}"/${PN}-desktop-keywords.patch
)

src_prepare() {
	default

	eautoreconf
}
