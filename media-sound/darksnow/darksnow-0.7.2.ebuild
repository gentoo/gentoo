# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop xdg

# darksnow is part of darkice as darkice-gui since 1.4
MY_PN="darkice"
MY_PV="1.6"
MY_P="${MY_PN}-${MY_PV}"
DESCRIPTION="Streaming GTK+ Front-End based on Darkice Ice Streamer"
HOMEPAGE="https://github.com/rafael2k/darkice"
SRC_URI="https://github.com/rafael2k/darkice/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}/${MY_PN}-gui/trunk"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

PDEPEND=">=media-sound/darkice-1.2"
RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
	# PR pending https://github.com/rafael2k/darkice/pull/208.patch
	"${FILESDIR}"/${P}-fix_overflow.patch
)

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	default
	emake -C po
}

src_install() {
	default
	dodoc documentation/{CHANGES,CREDITS,README*}

	domenu ${PN}.desktop
}
