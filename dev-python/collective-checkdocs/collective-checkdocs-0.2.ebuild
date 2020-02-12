# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 python3_7 )
inherit distutils-r1

DESCRIPTION="Distutils command to view/validate packages's rst text long_descriptions."
HOMEPAGE="https://github.com/collective/collective.checkdocs"
SRC_URI="mirror://pypi/${PN:0:1}/collective.checkdocs/collective.checkdocs-${PV}.zip"
S="${WORKDIR}/collective.checkdocs-${PV}"

LICENSE="GPL-2"  # until https://github.com/collective/collective.checkdocs/issues/8 is fixed
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/docutils[${PYTHON_USEDEP}]"
