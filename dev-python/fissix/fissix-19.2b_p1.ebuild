# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

MY_PV="${PV//_p/}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Backport of lib2to3, with enhancements"
HOMEPAGE="https://github.com/jreese/fissix"
SRC_URI="https://github.com/jreese/${PN}/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="PSF-2.4"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/appdirs[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

python_test() {
	"${EPYTHON}" -m unittest --verbose tests || die "Tests fail with ${EPYTHON}"
}
