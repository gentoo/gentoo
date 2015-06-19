# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/xfce4-terminal/xfce4-terminal-0.6.3.ebuild,v 1.11 2014/07/06 16:18:03 blueness Exp $

EAPI=5
inherit xfconf

DESCRIPTION="A terminal emulator for the Xfce desktop environment"
HOMEPAGE="http://www.xfce.org/projects/terminal/"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="debug"

RDEPEND=">=dev-libs/glib-2.26
	>=x11-libs/gtk+-2.24:2
	x11-libs/libX11
	>=x11-libs/vte-0.28:0
	>=xfce-base/libxfce4ui-4.10"
DEPEND="${RDEPEND}
	dev-libs/libxml2
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog HACKING NEWS README THANKS )
}
