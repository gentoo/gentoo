# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME_ORG_MODULE="gnome-themes-extra"

inherit gnome.org multilib-minimal

DESCRIPTION="Adwaita GTK+2 theme engine"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-themes-extra/"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"

DEPEND="
	>=x11-libs/gtk+-2.24.15:2[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="
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
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
