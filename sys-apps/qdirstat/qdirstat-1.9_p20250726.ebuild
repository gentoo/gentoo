# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=a888b289ecaa062466a1d5ba2b19e96bed5fb8c8
inherit qmake-utils xdg-utils

DESCRIPTION="Qt-based directory statistics"
HOMEPAGE="https://github.com/shundhammer/qdirstat"
SRC_URI="https://github.com/shundhammer/qdirstat/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~asturm/distfiles/${P}-qt6.patch.xz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-qt/qtbase:6[gui,widgets]
	sys-libs/zlib
"
RDEPEND="${DEPEND}
	dev-lang/perl
	dev-perl/URI
"

# Pending ... https://github.com/shundhammer/qdirstat/pull/279
PATCHES=( "${WORKDIR}/${P}-qt6.patch" ) # bug 947299

src_prepare() {
	default

	# Fix QA warning about incorrect use of doc path
	sed -e "/doc.path/s/${PN}/${PF}/" -i doc/doc.pro doc/stats/stats.pro || die

	# Don't install compressed man pages
	sed -e '/gzip/d' -e 's/.gz//g' -i man/man.pro || die
}

src_configure() {
	eqmake6
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
