# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="A GTK+ archive manager that can be used with Thunar"
HOMEPAGE="https://github.com/ib/xarchiver/"
SRC_URI="
	https://github.com/ib/xarchiver/archive/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc"

DEPEND="
	>=dev-libs/glib-2:=
	x11-libs/gtk+:3=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd
		app-text/docbook-xsl-stylesheets
		dev-libs/libxml2
		dev-libs/libxslt
	)
"

src_configure() {
	local myconf=(
		$(use_enable doc)
	)
	econf "${myconf[@]}"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	elog "You need external programs for some formats, including:"
	elog "7zip - app-arch/p7zip"
	elog "arj - app-arch/arj"
	elog "lha - app-arch/lha"
	elog "lzop - app-arch/lzop"
	elog "rar - app-arch/unrar app-arch/rar"
	elog "zip - app-arch/unzip app-arch/zip"
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
