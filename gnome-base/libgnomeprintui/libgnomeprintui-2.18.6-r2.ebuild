# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME_TARBALL_SUFFIX="bz2"

inherit autotools gnome2 multilib-minimal

DESCRIPTION="User interface libraries for gnome print"
HOMEPAGE="https://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="2.2"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	>=gnome-base/libgnomeprint-2.12.1[${MULTILIB_USEDEP}]
	>=gnome-base/libgnomecanvas-1.117[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-2.6:2[${MULTILIB_USEDEP}]
	x11-themes/adwaita-icon-theme
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

src_prepare() {
	# Patches from Mageia
	eapply "${FILESDIR}"/${P}-adwaita-icon-theme.patch
	eapply "${FILESDIR}"/${P}-intl.patch
	eapply "${FILESDIR}"/${P}-orientation-for-preview.patch
	eapply "${FILESDIR}"/${P}-system-config-printer.patch
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
