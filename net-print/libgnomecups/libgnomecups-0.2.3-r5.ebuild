# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
GCONF_DEBUG="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit autotools eutils gnome2 multilib-minimal

DESCRIPTION="GNOME cups library"
HOMEPAGE="https://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=net-print/cups-1.7.1-r1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.28
	gnome-base/gnome-common
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/enablenet.patch

	# Fix .pc file per bug #235013
	epatch "${FILESDIR}"/${P}-pkgconfig.patch

	# Upstream fix for g_list_find_custom() argument order
	epatch "${FILESDIR}/${P}-g_list_find_custom.patch"

	# >=glib-2.31 compat, bug #400789, https://bugzilla.gnome.org/show_bug.cgi?id=664930
	epatch "${FILESDIR}/${P}-glib.h.patch"

	# cups-1.6 compat, bug #428812
	epatch "${FILESDIR}/${P}-cups-1.6.patch"

	# so it looks for cups-config... how about using $CUPS_CONFIG then?
	# and also use AC_PATH_TOOL to respect $CHOST
	epatch "${FILESDIR}/${P}-cups-config.patch"

	# Fix building with -Werror=format-security, bug #517612
	epatch "${FILESDIR}/${P}-format-string.patch"

	# Look for lpoptions in the right spot, upstream bug #520449
	epatch "${FILESDIR}/${P}-lpoptions.patch"

	eautoreconf # To fix intltool files making LINGUAS to be honored
	gnome2_src_prepare
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	gnome2_src_configure --disable-static
}

multilib_src_install() {
	gnome2_src_install
}
