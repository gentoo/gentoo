# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

MY_PN="Flask-Sphinx-Themes"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Sphinx Themes for Flask related projects and Flask itself"
HOMEPAGE="https://github.com/pallets/flask-sphinx-themes https://pypi.org/project/Flask-Sphinx-Themes/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/${P}-python2-encoding-kw.patch" )

S="${WORKDIR}/${MY_P}"
