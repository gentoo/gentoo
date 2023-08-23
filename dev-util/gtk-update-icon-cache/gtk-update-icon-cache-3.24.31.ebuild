# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson plocale

PLOCALES="af am an ang ar as ast az az_IR be be@latin bg bn bn_IN br bs ca ca@valencia ckb crh cs cy da de dz el en en_CA en_GB en@shaw eo es et eu fa fi fr fur ga gd gl gu he hi hr hu hy ia id io is it ja ka kg kk km kn ko ku ky lg li lt lv mai mi mk ml mn mr ms my nb nds ne nl nn nso oc or pa pl ps pt pt_BR ro ru rw si sk sl sq sr sr@ije sr@latin sv ta te tg th tk tr tt ug uk ur uz uz@cyrillic vi wa xh yi zh_CN zh_HK zh_TW"

DESCRIPTION="GTK update icon cache"
HOMEPAGE="https://www.gtk.org/ https://gitlab.gnome.org/Community/gentoo/gtk-update-icon-cache"
SRC_URI="https://gitlab.gnome.org/Community/gentoo/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"
IUSE="man"

# man page was previously installed by gtk+:3 ebuild
RDEPEND="
	>=dev-libs/glib-2.53.4:2
	>=x11-libs/gdk-pixbuf-2.30:2
	!<x11-libs/gtk+-2.24.28-r1:2
	!<x11-libs/gtk+-3.22.2:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	man? (
		app-text/docbook-xml-dtd:4.3
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	)
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	default
	plocale_get_locales > po/LINGUAS || die
}

src_configure() {
	local emesonargs=(
		$(meson_use man man-pages)
	)
	meson_src_configure
}
