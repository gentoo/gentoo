# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 python3_6 python3_7 )
PYTHON_REQ_USE="threads(+)"

inherit apache-module eutils python-single-r1

DESCRIPTION="An Apache2 module for running Python WSGI applications"
HOMEPAGE="https://github.com/GrahamDumpleton/mod_wsgi"
SRC_URI="https://github.com/GrahamDumpleton/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="${PYTHON_DEPS}"

APACHE2_MOD_CONF="70_${PN}"
APACHE2_MOD_DEFINE="WSGI"
APACHE2_MOD_FILE="${S}/src/server/.libs/${PN}.so"

DOCFILES="README.rst"

need_apache2

src_configure() {
	econf --with-apxs=${APXS} --with-python=${PYTHON}
}

src_compile() {
	default
}
