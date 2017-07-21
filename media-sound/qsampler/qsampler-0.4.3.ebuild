# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils qmake-utils

DESCRIPTION="A graphical frontend to the LinuxSampler engine"
HOMEPAGE="http://qsampler.sourceforge.net http://www.linuxsampler.org/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +libgig"

DEPEND="media-libs/alsa-lib
	>=media-libs/liblscp-0.5.6:=
	x11-libs/libX11
	libgig? ( >=media-libs/libgig-3.3.0:= )
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtx11extras:5
	dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}
	>=media-sound/linuxsampler-0.5"
DEPEND="${DEPEND}
	dev-qt/linguist-tools:5"

src_configure() {
	ac_qmake="$(qt5_get_bindir)/qmake" \
		econf $(use_enable debug) \
		$(use_enable libgig) \
		--disable-qt4
	cd "${S}/src"
	eqmake5 src.pro -o Makefile
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README TODO TRANSLATORS
	doman ${PN}.1
}
