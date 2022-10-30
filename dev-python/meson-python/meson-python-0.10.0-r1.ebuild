# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Meson PEP 517 Python build backend"
HOMEPAGE="
	https://pypi.org/project/meson-python/
	https://github.com/mesonbuild/meson-python/
"
SRC_URI="
	https://github.com/mesonbuild/meson-python/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~s390 x86"

RDEPEND="
	>=dev-python/pyproject-metadata-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/tomli-1.0.0[${PYTHON_USEDEP}]
	>=dev-util/meson-0.63.0[${PYTHON_USEDEP}]
	dev-util/patchelf
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/GitPython[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.0-defaults.patch
)

distutils_enable_sphinx docs \
	dev-python/furo \
	dev-python/sphinx-autodoc-typehints
distutils_enable_tests pytest

src_prepare() {
	# strip dependency on ninja -- we provide ninja via Gentoo package
	# rather than the Python wheel, so we don't have .dist-info there
	sed -i -e '/ninja/d' pyproject.toml || die
	distutils-r1_src_prepare
}
