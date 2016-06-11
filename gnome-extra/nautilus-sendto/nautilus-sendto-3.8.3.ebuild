# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"

inherit gnome2

DESCRIPTION="A nautilus extension for sending files to locations"
HOMEPAGE="https://git.gnome.org/browse/nautilus-sendto/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
	>=x11-libs/gtk+-2.90.3:3[X(+)]
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
"
# Needed for eautoreconf
#	>=gnome-base/gnome-common-0.12

src_prepare() {
	gnome2_src_prepare

	# Does not require introspection at all, bug #561008
	sed -i -e 's/\(^ \+enable_introspection\)=yes/\1=no/' configure || die
}
