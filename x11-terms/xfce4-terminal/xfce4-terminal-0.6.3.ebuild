# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit xfconf

DESCRIPTION="A terminal emulator for the Xfce desktop environment"
HOMEPAGE="https://docs.xfce.org/apps/terminal/start"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x64-solaris"
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
