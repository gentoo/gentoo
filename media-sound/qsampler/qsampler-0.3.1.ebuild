# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils qmake-utils

DESCRIPTION="A graphical frontend to the LinuxSampler engine"
HOMEPAGE="http://www.linuxsampler.org/"
SRC_URI="http://download.linuxsampler.org/packages/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +libgig qt4 +qt5"
REQUIRED_USE="^^ ( qt4 qt5 )"

DEPEND="media-libs/alsa-lib
	>=media-libs/liblscp-0.5.6:=
	x11-libs/libX11
	libgig? ( >=media-libs/libgig-3.3.0:= )
	qt4? ( dev-qt/qtcore:4
		dev-qt/qtgui:4 )
	qt5? ( dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5 )"
RDEPEND="${DEPEND}
	>=media-sound/linuxsampler-0.5"
DEPEND="${DEPEND}
	qt5? ( dev-qt/linguist-tools:5 )"

src_configure() {
	econf $(use_enable debug) \
		$(use_enable libgig) \
		$(use_enable qt4) \
		$(use_enable qt5)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README TODO TRANSLATORS
	doman ${PN}.1
}
