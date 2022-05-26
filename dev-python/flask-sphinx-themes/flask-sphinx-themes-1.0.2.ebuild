# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="Flask-Sphinx-Themes"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( pypy3 python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Sphinx Themes for Flask related projects and Flask itself"
HOMEPAGE="https://github.com/pallets/flask-sphinx-themes https://pypi.org/project/Flask-Sphinx-Themes/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"
