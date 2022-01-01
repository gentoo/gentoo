# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="Simple powerful testing with Python"
HOMEPAGE="https://pytest.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~s390 sparc x86"
RESTRICT="test"

# When bumping, please check setup.py for the proper py version
PY_VER="1.5.0"

# pathlib2 has been added to stdlib before py3.6, but pytest needs __fspath__
# support, which only came in py3.6.
RDEPEND="
	>=dev-python/atomicwrites-1.0[${PYTHON_USEDEP}]
	>=dev-python/attrs-17.4.0[${PYTHON_USEDEP}]
	>=dev-python/more-itertools-4.0.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/importlib_metadata[${PYTHON_USEDEP}]
	' -2 python3_{5,6,7} pypy3)
	$(python_gen_cond_dep '
		dev-python/pathlib2[${PYTHON_USEDEP}]
		dev-python/funcsigs[${PYTHON_USEDEP}]
	' -2)
	>=dev-python/pluggy-0.12[${PYTHON_USEDEP}]
	<dev-python/pluggy-1
	>=dev-python/py-${PY_VER}[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wcwidth[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/pytest-4.5.0-strip-setuptools_scm.patch"
	"${FILESDIR}/pytest-4.6.10-timeout.patch"
)

python_prepare_all() {
	grep -qF "py>=${PY_VER}" setup.py || die "Incorrect dev-python/py dependency"

	distutils-r1_python_prepare_all
}
