# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
GNOME_ORG_MODULE="${PN/pp/++}"

inherit gnome2 multilib-minimal

DESCRIPTION="C++ wrapper for the libxml2 XML parser library"
HOMEPAGE="http://libxmlplusplus.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="2.6"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc"

RDEPEND="
	>=dev-libs/libxml2-2.7.7[${MULTILIB_USEDEP}]
	>=dev-cpp/glibmm-2.32[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

multilib_src_prepare() {
	gnome2_src_prepare
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" gnome2_src_configure \
		$(use_enable doc documentation)
}

multilib_src_install() {
	gnome2_src_install
}
