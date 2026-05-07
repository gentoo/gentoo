# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Define click command line options from a python dataclass"
HOMEPAGE="
	https://github.com/Kamilcuk/clickdc
	https://pypi.org/project/clickdc/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pydantic[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# Irrevelant downstream, unpackaged pyright
	"tests/test_typing.py"
)
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/clickdc-0.1.1-click-8.2.patch
)

python_prepare_all() {
	# workaround setuptools-git-versioning
	sed -e "/^\[project\]/aversion = \"${PV}\"" \
		-e '/^dynamic =/ s/"version", //' \
		-i pyproject.toml || die

	distutils-r1_python_prepare_all
}
