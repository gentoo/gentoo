# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit ltprune

DESCRIPTION="GObject-based XIM protocol library"
HOMEPAGE="https://tagoh.bitbucket.io/libgxim"
SRC_URI="https://bitbucket.org/tagoh/${PN}/downloads/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

RDEPEND="dev-libs/dbus-glib
	dev-libs/glib:2
	sys-apps/dbus
	virtual/libintl
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-libs/check
	dev-lang/ruby
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.8 )"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
