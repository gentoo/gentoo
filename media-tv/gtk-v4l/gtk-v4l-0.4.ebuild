# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="A control application for Video 4 Linux (based on C and GTK+)"
HOMEPAGE="http://fedorahosted.org/gtk-v4l/"
SRC_URI="http://fedorahosted.org/releases/${PN:0:1}/${PN:1:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2
	>=media-libs/libv4l-0.6
	virtual/libgudev:=
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS ChangeLog README"

src_prepare() {
	epatch "${FILESDIR}"/${P}-device-remove-source-on-finalize.patch
	sed -i -e '/^Categories/s:Application:GTK:' ${PN}.desktop.in || die
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	prune_libtool_files --all
}
