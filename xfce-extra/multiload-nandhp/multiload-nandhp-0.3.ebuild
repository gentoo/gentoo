# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/multiload-nandhp/multiload-nandhp-0.3.ebuild,v 1.1 2015/07/13 05:05:06 mgorny Exp $

EAPI=5
inherit autotools eutils

MY_PV=version-${PV/./-}

DESCRIPTION="A port of the GNOME multiload applet for the Xfce panel"
HOMEPAGE="http://github.com/nandhp/multiload-nandhp"
SRC_URI="http://github.com/nandhp/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.14:2=
	x11-libs/cairo:=
	>=gnome-base/libgtop-2.11.92:=
	>=xfce-base/libxfce4ui-4.10:=
	>=xfce-base/libxfce4util-4.10:=
	>=xfce-base/xfce4-panel-4.10:="

DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

DOCS="AUTHORS README.md"

S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	eautoreconf
}

src_configure() {
	econf --with-xfce4
}

src_install() {
	default
	prune_libtool_files --all
}
