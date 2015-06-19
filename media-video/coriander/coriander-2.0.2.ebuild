# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/coriander/coriander-2.0.2.ebuild,v 1.1 2015/02/05 16:40:00 pacho Exp $

EAPI=5
inherit eutils

DESCRIPTION="A Gnome2 GUI for firewire camera control and capture"
HOMEPAGE="http://sourceforge.net/projects/coriander/"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

# ffmpeg? ( media-video/ffmpeg ) left out, because ffmpeg support is in
# development
RDEPEND="
	>=media-libs/libdc1394-2.0.0
	media-libs/libsdl
	media-libs/tiff:0
	gnome-base/libgnomeui
	gnome-base/libbonoboui
	gnome-base/libgnomecanvas
	gnome-base/libgnome
	gnome-base/orbit
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
