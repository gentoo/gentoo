# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )

inherit xdg-utils eutils python-single-r1 flag-o-matic

DESCRIPTION="Application to organise documents or references, and to generate BibTeX files"
HOMEPAGE="https://launchpad.net/referencer"
SRC_URI="https://launchpad.net/${PN}/1./${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=app-text/poppler-0.12.3-r3:=[cairo]
	>=dev-cpp/gtkmm-2.8:*
	>=dev-cpp/libglademm-2.6.0
	>=dev-cpp/gconfmm-2.14.0
	>=dev-libs/boost-1.52.0-r4"

DEPEND="
	${RDEPEND}
	>=app-text/gnome-doc-utils-0.3.2
	virtual/pkgconfig
	>=dev-lang/perl-5.8.1
	dev-perl/libxml-perl
	dev-util/intltool
	app-text/rarian"

PATCHES=( ${FILESDIR}/${PN}-${PV}-lib_path.patch )

src_prepare () {
	default
	python_fix_shebang plugins
}

src_configure() {
	append-cxxflags -std=gnu++11
	econf \
		--disable-update-mime-database \
		--enable-python
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
