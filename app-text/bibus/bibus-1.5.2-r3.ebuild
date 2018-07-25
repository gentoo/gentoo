# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit python-r1 versionator xdg-utils

DESCRIPTION="Bibliographic and reference management software, integrates with LO and MS Word"
HOMEPAGE="http://bibus-biblio.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}-biblio/${PN}_${PV}.orig.tar.gz
	https://dev.gentoo.org/~jlec/distfiles/${P}-lo-4.patch.xz
	"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="mysql"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Most of this mess is designed to give the choice of sqlite or mysql
# but prefer sqlite. We also need to default to sqlite if neither is requested.
# Cannot depend on virtual/ooo
# bibus fails to start with app-office/openoffice-bin (bug #288232).
RDEPEND="
	${PYTHON_DEPS}
	app-office/libreoffice
	dev-python/wxpython:3.0[${PYTHON_USEDEP}]
	dev-db/sqliteodbc
	dev-db/unixODBC
	mysql? (
		dev-python/mysql-python[${PYTHON_USEDEP}]
		dev-db/myodbc
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-install.patch
	"${FILESDIR}"/${P}-bibus.cfg.patch
	"${WORKDIR}"/${P}-lo-4.patch
	"${FILESDIR}"/${P}-wx30.patch
)

pkg_setup() {
	if [[ -d "/usr/$(get_libdir)/openoffice" ]] ; then
		OFFICESUITE="/usr/$(get_libdir)/openoffice"
	else
		OFFICESUITE="/usr/$(get_libdir)/libreoffice"
	fi
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
			python=${PYTHON} \
			install install-doc-en
	}
	python_foreach_impl installation
	python_foreach_impl python_optimize

	python_foreach_impl python_newscript bibusStart.py ${PN}
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
