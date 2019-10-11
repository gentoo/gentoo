# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools gnome2 multilib-minimal

DESCRIPTION="GL extensions for Gtk+ 2.0"
HOMEPAGE="http://gtkglext.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-2.24.23:2[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.36.3[${MULTILIB_USEDEP}]
	>=x11-libs/pangox-compat-0.0.2[${MULTILIB_USEDEP}]
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXmu-1.1.1-r1[${MULTILIB_USEDEP}]
	>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
	>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=sys-devel/autoconf-archive-2014.02.28
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

src_prepare() {
	# Fix build issues with gcc patch from Fedora, bug #649718
	eapply "${FILESDIR}"/${P}-gcc8-fixes.patch

	# Ancient configure.in with broken multilib gl detection (bug #543050)
	# Backport some configure updates from upstream git master to fix
	eapply "${FILESDIR}/${P}-gl-configure.patch"

	mv configure.{in,ac} || die "mv failed"
	eautoreconf

	gnome2_src_prepare
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-static
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	local DOCS="AUTHORS ChangeLog* NEWS README TODO"
	einstalldocs
}
