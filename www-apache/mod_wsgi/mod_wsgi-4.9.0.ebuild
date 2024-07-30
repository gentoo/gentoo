# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )
PYTHON_REQ_USE="threads(+)"

inherit apache-module python-single-r1

DESCRIPTION="An Apache2 module for running Python WSGI applications"
HOMEPAGE="https://github.com/GrahamDumpleton/mod_wsgi"
SRC_URI="https://github.com/GrahamDumpleton/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="${PYTHON_DEPS}"

APACHE2_MOD_CONF="70_${PN}"
APACHE2_MOD_DEFINE="WSGI"
APACHE2_MOD_FILE="${S}/src/server/.libs/${PN}.so"

DOCFILES="README.rst"

need_apache2

pkg_setup() {
	python-single-r1_pkg_setup

	# Calling depend.apache_pkg_setup fails because we do not have
	# "apache2" in IUSE but the function expects this in order to call
	# _init_apache2_late which sets the APACHE_MODULESDIR variable.
	_init_apache2
	_init_apache2_late
}

src_configure() {
	econf --with-apxs="${APXS}" --with-python="${PYTHON}"
}

src_compile() {
	default
}
