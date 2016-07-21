# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Lightweight vte-based tabbed terminal emulator for LXDE"
HOMEPAGE="http://lxde.sf.net/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~x86 ~x86-interix ~amd64-linux ~arm-linux ~x86-linux"
SLOT="0"
IUSE="gtk3"

RDEPEND="dev-libs/glib:2
	!gtk3? ( x11-libs/gtk+:2 x11-libs/vte:0 )
	gtk3?  ( x11-libs/gtk+:3 x11-libs/vte:2.90 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	>=dev-util/intltool-0.40.0"

DOCS=( AUTHORS README )

src_configure() {
	econf $(use_enable gtk3)
}
