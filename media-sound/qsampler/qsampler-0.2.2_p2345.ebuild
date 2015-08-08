# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils qt4-r2

MY_P=${P/_p/.}
DESCRIPTION="A graphical frontend to the LinuxSampler engine"
HOMEPAGE="http://qsampler.sourceforge.net"
SRC_URI="mirror://gentoo/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +libgig"

DEPEND="media-libs/alsa-lib
	>=media-libs/liblscp-0.5.5
	x11-libs/libX11
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	libgig? ( >=media-libs/libgig-3.2.1 )"
RDEPEND="${DEPEND}
	>=media-sound/linuxsampler-0.5"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf $(use_enable debug) \
		$(use_enable libgig)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README TODO
	doman debian/${PN}.1
}
