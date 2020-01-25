# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Python MPD client library"
HOMEPAGE="https://github.com/Mic92/python-mpd2"
SRC_URI="https://github.com/Mic92/${PN}2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
IUSE="test +twisted"

REQUIRED_USE="test? ( twisted )"

BDEPEND="
	test? (
		dev-python/filelock[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/toml[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
	)
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DEPEND="twisted? ( dev-python/twisted[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

RESTRICT="!test? ( test )"

DOCS=( doc/changes.rst doc/topics/{advanced,commands,getting-started,logging}.rst README.rst )

S="${WORKDIR}/${PN}2-${PV}"

distutils_enable_tests setup.py

python_prepare_all() {
	distutils-r1_python_prepare_all
	rm tox.ini || die
}
