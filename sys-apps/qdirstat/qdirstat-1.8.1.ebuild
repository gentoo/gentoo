# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg-utils

DESCRIPTION="Qt-based directory statistics"
HOMEPAGE="https://github.com/shundhammer/qdirstat"
SRC_URI="https://github.com/shundhammer/qdirstat/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	sys-libs/zlib
"

RDEPEND="
	${DEPEND}
	dev-lang/perl
	dev-perl/URI
"

src_prepare() {
	default

	# Fix QA warning about incorrect use of doc path
	sed -e "/doc.path/s/${PN}/${PF}/" -i doc/doc.pro doc/stats/stats.pro || die

	# Don't install compressed man pages
	sed -e '/gzip/d' -e 's/.gz//g' -i man/man.pro || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
