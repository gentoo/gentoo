# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

MY_PN="MiniMock"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="The simplest possible mock library"
HOMEPAGE="https://pypi.org/project/MiniMock/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ppc x86"

# future breaks minimock hard -- probably makes it think it's on python3...
# https://github.com/lowks/minimock/issues/5
RDEPEND="$(python_gen_cond_dep '!!dev-python/future[${PYTHON_USEDEP}]' -2)"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

DOCS=( docs/changelog.rst docs/index.rst )

python_test() {
	"${PYTHON}" -m doctest minimock.py || die "Tests fail with ${EPYTHON}"
}
