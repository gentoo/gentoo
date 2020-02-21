# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit perl-module

DESCRIPTION="A gtk-perl mplayer/mencoder frontend for ripping DVDs"
HOMEPAGE="https://sourceforge.net/projects/acidrip/"
SRC_URI="https://sourceforge.net/projects/${PN}/files/${PN}/${PV}%20-%20Your%20two-wheeled%20knife/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="encode"

RDEPEND="dev-perl/Gtk2
	media-video/lsdvd
	media-video/mplayer[encode]
	encode? ( >=media-sound/lame-3.92 )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-mplayer.patch #168012
	epatch "${FILESDIR}/${P}-makefile.patch" #299173
	perl-module_src_prepare
}
