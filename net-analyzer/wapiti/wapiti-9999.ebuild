# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE='xml'

inherit distutils-r1 git-r3

DESCRIPTION="Web-application vulnerability scanner"
HOMEPAGE="http://wapiti.sourceforge.net/"
EGIT_REPO_URI="https://git.code.sf.net/p/wapiti/git wapiti-git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="kerberos ntlm"

RDEPEND="dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	>=dev-python/requests-1.2.3[${PYTHON_USEDEP}]
	dev-python/tld[${PYTHON_USEDEP}]
	dev-python/yaswfp[${PYTHON_USEDEP}]
	kerberos? ( dev-python/requests-kerberos[${PYTHON_USEDEP}] )
	ntlm? ( dev-python/requests-ntlm[${PYTHON_USEDEP}] )"

distutils_enable_tests --install pytest
BDEPEND+=" test? ( dev-python/responses[${PYTHON_USEDEP}] )"
# Many tests require execution of local test php server
RESTRICT="test"

python_prepare_all() {
	sed -e 's/"pytest-runner"//' \
		-e "/find_packages/s/()/(exclude=['tests*'])/" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}
