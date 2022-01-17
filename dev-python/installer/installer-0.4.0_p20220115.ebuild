# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=manual
PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

EGIT_COMMIT="bf68f7b045ffc08784af03cf2433548c9ee9e8ca"
DESCRIPTION="A library for installing Python wheels"
HOMEPAGE="
	https://pypi.org/project/installer/
	https://github.com/pradyunsg/installer/
	https://installer.readthedocs.io/en/latest/
"
SRC_URI="
	https://github.com/pradyunsg/installer/archive/${EGIT_COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
	https://files.pythonhosted.org/packages/py2.py3/${PN::1}/${PN}/${P%_p*}-py2.py3-none-any.whl
		-> ${P%_p*}-py2.py3-none-any.whl.zip
	https://patch-diff.githubusercontent.com/raw/pradyunsg/installer/pull/94.diff
		-> ${P}-cli.patch
"
S=${WORKDIR}/${PN}-${EGIT_COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# NB: newer git doesn't use mock anymore
BDEPEND="
	app-arch/unzip
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${DISTDIR}"/${P}-cli.patch
)

# do not use any build system to avoid circular deps
python_compile() { :; }

python_test() {
	local -x PYTHONPATH=src
	epytest
}

python_install() {
	python_domodule src/installer "${WORKDIR}"/*.dist-info
}
