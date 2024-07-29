# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

EGIT_COMMIT=ab623b0e287a9303bdb0c5213c485110e68dac12
MY_P=python-iniparse-${EGIT_COMMIT}

DESCRIPTION="Better INI parser for Python"
HOMEPAGE="
	https://github.com/candlepin/python-iniparse/
	https://pypi.org/project/iniparse/
"
SRC_URI="
	https://github.com/candlepin/python-iniparse/archive/${EGIT_COMMIT}.tar.gz
		-> ${MY_P}.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT PSF-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

RDEPEND="
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
"

src_prepare() {
	local PATCHES=(
		# https://github.com/candlepin/python-iniparse/pull/29
		"${FILESDIR}/${P}-py3.11.7.patch"
	)

	distutils-r1_src_prepare

	# https://src.fedoraproject.org/rpms/python-iniparse/blob/rawhide/f/python-iniparse.spec
	sed -e "s/unittest.makeSuite(\(.*\), 'test')/unittest.defaultTestLoader.loadTestsFromTestCase(\1)/g" \
		-i tests/test*.py || die
}

python_test() {
	"${EPYTHON}" runtests.py -v || die
}

python_install_all() {
	rm -rf "${ED}/usr/share/doc" || die
	distutils-r1_python_install_all
}
