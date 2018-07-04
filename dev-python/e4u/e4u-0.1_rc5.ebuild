# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PV="${PV/_/}"

DESCRIPTION="A library for handling unicode emoji and carrier's emoji"
HOMEPAGE="https://github.com/lambdalisue/e4u"
SRC_URI="https://github.com/lambdalisue/e4u/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="dev-python/beautifulsoup:python-2[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"

DEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=( "${FILESDIR}"/change-emoji4unicode-url.patch )

python_test() {
	esetup.py test
}

python_install_all() {
	insinto /usr/share/e4u
	doins e4u/data/emoji4unicode.xml

	distutils-r1_python_install_all
}
