# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1

EGIT_COMMIT=fdeeda5f6fe3ed8905deb7a067cc5951a477d091
MY_P=${PN}-${EGIT_COMMIT}
DESCRIPTION="Python docutils-compatibility bridge to CommonMark"
HOMEPAGE="https://recommonmark.readthedocs.io/"
SRC_URI="https://github.com/rtfd/recommonmark/archive/${EGIT_COMMIT}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/commonmark-0.8[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.3.1[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

S=${WORKDIR}/${MY_P}

python_test() {
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
