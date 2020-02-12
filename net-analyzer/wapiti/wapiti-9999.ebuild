# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE='xml'

inherit distutils-r1 git-r3

DESCRIPTION="Web-application vulnerability scanner"
HOMEPAGE="http://wapiti.sourceforge.net/"
EGIT_REPO_URI="https://git.code.sf.net/p/wapiti/git wapiti-git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="kerberos ntlm test"

RESTRICT="!test? ( test )"

DEPEND="test? (
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/pytest-runner[${PYTHON_USEDEP}]
	)"
RDEPEND="dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	>=dev-python/requests-1.2.3[${PYTHON_USEDEP}]
	dev-python/tld[${PYTHON_USEDEP}]
	dev-python/yaswfp[${PYTHON_USEDEP}]
	kerberos? ( dev-python/requests-kerberos[${PYTHON_USEDEP}] )
	ntlm? ( dev-python/requests-ntlm[${PYTHON_USEDEP}] )"

python_prepare_all() {
	sed -e 's/"pytest-runner"//' -i setup.py || die
	distutils-r1_python_prepare_all
}
