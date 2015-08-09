# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Profiling and leak detection tool"
HOMEPAGE="http://www.secretlabs.de/projects/memprof/"
SRC_URI="http://www.secretlabs.de/projects/memprof/releases/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND="dev-libs/glib:2
	>=gnome-base/libglade-2
	>=x11-libs/gtk+-2.6:2
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( dev-util/intltool
		sys-devel/gettext )"

DOCS=( AUTHORS ChangeLog README NEWS )

src_prepare() {
	epatch "${FILESDIR}"/${P}-binutils.patch
	epatch "${FILESDIR}"/${P}-desktop.patch
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable nls)
}

src_install() {
	default
	prune_libtool_files --modules
}
