# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

MY_P="Flask-Migrate-${PV}"
DESCRIPTION="SQLAlchemy database migrations for Flask applications using Alembic"
HOMEPAGE="
	https://github.com/miguelgrinberg/Flask-Migrate/
	https://pypi.org/project/Flask-Migrate/
"
SRC_URI="
	https://github.com/miguelgrinberg/Flask-Migrate/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-python/alembic-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/flask-0.9[${PYTHON_USEDEP}]
	>=dev-python/flask-sqlalchemy-1.0[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

python_test() {
	local -x PATH=${T}/bin:${PATH}

	mkdir -p "${T}"/bin || die
	cat > "${T}"/bin/flask <<-EOF || die
		#!/bin/sh
		exec ${EPYTHON} -m flask "\${@}"
	EOF
	chmod +x "${T}"/bin/flask || die

	eunittest
}
