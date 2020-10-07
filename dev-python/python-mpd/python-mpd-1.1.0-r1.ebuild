# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS="bdepend"
PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Python MPD client library"
HOMEPAGE="https://github.com/Mic92/python-mpd2"
SRC_URI="https://github.com/Mic92/${PN}2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
IUSE="examples +twisted"

REQUIRED_USE="test? ( twisted )"

RDEPEND="twisted? ( dev-python/twisted[${PYTHON_USEDEP}] )"

DEPEND="${RDEPEND}"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/toml[${PYTHON_USEDEP}]
	)
"

DOCS=( README.rst doc/{changes.rst,commands_header.txt} doc/topics/. )

S="${WORKDIR}/${PN}2-${PV}"

distutils_enable_sphinx doc --no-autodoc
distutils_enable_tests pytest

python_test() {
	pytest mpd/tests.py -vv || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	use examples && dodoc -r examples/.
}
