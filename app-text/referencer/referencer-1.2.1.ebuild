# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_DEPEND="2:2.7"

inherit fdo-mime eutils flag-o-matic python

DESCRIPTION="Gnome application to organise documents or references, and to generate BibTeX bibliography files"
HOMEPAGE="https://launchpad.net/referencer"
SRC_URI="https://launchpad.net/${PN}/1./${PV}/+download/$P.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND=">=app-text/poppler-0.12.3-r3:=[cairo]
	>=dev-cpp/gtkmm-2.8
	>=dev-cpp/libglademm-2.6.0
	>=dev-cpp/gconfmm-2.14.0
	>=dev-libs/boost-1.52.0-r4"

DEPEND="${RDEPEND}
	>=app-text/gnome-doc-utils-0.3.2
	virtual/pkgconfig
	>=dev-lang/perl-5.8.1
	dev-perl/libxml-perl
	dev-util/intltool
	app-text/rarian"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare () {
	python_convert_shebangs -r 2.7 plugins
}

src_configure() {
	append-cxxflags -std=c++11
	econf --disable-update-mime-database --enable-python
}

pkg_postinst() {
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_mime_database_update
}
