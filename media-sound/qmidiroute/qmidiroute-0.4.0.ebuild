# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic qmake-utils

DESCRIPTION="QMidiRoute is a filter/router for MIDI events"
HOMEPAGE="http://alsamodular.sourceforge.net"
SRC_URI="mirror://sourceforge/alsamodular/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	media-libs/alsa-lib"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-drop-qtopengl.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cxxflags '-std=c++11'
	export PATH="$(qt5_get_bindir):${PATH}"
	econf --enable-qt5
}
