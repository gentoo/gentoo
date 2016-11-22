# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Library to create and utilize caches to speed up freedesktop application menus"
HOMEPAGE="http://lxde.sourceforge.net/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
# ABI is v2. See Makefile.am
SLOT="0/2"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-libs/glib:2
	x11-libs/libfm-extra"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"
