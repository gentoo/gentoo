# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1 pypi

DESCRIPTION="Python FTP server library"
HOMEPAGE="
	https://github.com/giampaolo/pyftpdlib/
	https://pypi.org/project/pyftpdlib/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
IUSE="examples ssl"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pyasynchat[${PYTHON_USEDEP}]
		dev-python/pyasyncore[${PYTHON_USEDEP}]
	' 3.12 3.13 3.14)
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/sphinx-rtd-theme

python_test() {
	rm -rf pyftpdlib || die
	# Tests fail with TZ=GMT, see https://bugs.gentoo.org/666623
	local -x TZ=UTC+1
	# Skips some shoddy tests plus increases timeouts
	local -x TRAVIS=1
	epytest -o addopts= tests
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r demo/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
