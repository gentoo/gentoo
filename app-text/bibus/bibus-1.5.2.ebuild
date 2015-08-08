# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-pypy-*"
PYTHON_USE_WITH=sqlite

inherit eutils fdo-mime multilib python versionator

DESCRIPTION="Bibliographic and reference management software, integrates with L/OO.o and MS Word"
HOMEPAGE="http://bibus-biblio.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}-biblio/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mysql"

# Most of this mess is designed to give the choice of sqlite or mysql
# but prefer sqlite. We also need to default to sqlite if neither is requested.
# Cannot depend on virtual/ooo
# bibus fails to start with app-office/openoffice-bin (bug #288232).
RDEPEND="
	app-office/libreoffice
	=dev-python/wxpython-2.8*
	dev-db/sqliteodbc
	dev-db/unixODBC
	mysql? (
		dev-python/mysql-python
		dev-db/myodbc
	)"
DEPEND="${RDEPEND}"

pkg_setup() {
	python_pkg_setup
	if [[ -d "/usr/$(get_libdir)/openoffice" ]] ; then
		OFFICESUITE="/usr/$(get_libdir)/openoffice"
	else
		OFFICESUITE="/usr/$(get_libdir)/libreoffice"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-install.patch
}

src_compile() { :; }

src_install() {
	einfo "Installing for ${OFFICESUITE}"
	installation() {
		emake \
			DESTDIR="${D}" \
			prefix="${EPREFIX}/usr" \
			oopath="${OFFICESUITE}/program" \
			ooure="${OFFICESUITE}/ure-link/lib" \
			oobasis="${OFFICESUITE}/program" \
			sysconfdir="${EPREFIX}/etc" \
			pythondir="$(python_get_sitedir)" \
			python=$(PYTHON -a) \
			install install-doc-en
	}
	python_execute_function installation
}

pkg_postinst() {
	python_mod_optimize bibus
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	python_mod_cleanup bibus
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
