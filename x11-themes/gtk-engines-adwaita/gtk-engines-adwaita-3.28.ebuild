# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME_ORG_MODULE="gnome-themes-extra"

inherit gnome.org multilib-minimal

DESCRIPTION="Adwaita GTK+2 theme engine"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-themes-extra/"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"

COMMON_DEPEND="
	>=x11-libs/gtk+-2.24.15:2[${MULTILIB_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}
	!<x11-themes/gnome-themes-standard-3.20.2-r1
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-static \
		--enable-gtk2-engine \
		--disable-gtk3-engine \
		GTK_UPDATE_ICON_CACHE=$(type -P true)
}

multilib_src_compile() {
	emake -C themes/Adwaita/gtk-2.0 libadwaita.la
}

multilib_src_install() {
	emake -C themes/Adwaita/gtk-2.0 DESTDIR="${D}" install-engineLTLIBRARIES
	find "${D}" -name '*.la' -delete || die
}
