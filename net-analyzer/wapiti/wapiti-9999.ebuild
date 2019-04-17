# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )
PYTHON_REQ_USE='xml'

ESVN_REPO_URI="https://svn.code.sf.net/p/wapiti/code/trunk/"
inherit distutils-r1 subversion

DESCRIPTION="Web-application vulnerability scanner"
HOMEPAGE="http://wapiti.sourceforge.net/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="kerberos ntlm"

DEPEND=""
RDEPEND="dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	>=dev-python/requests-1.2.3[${PYTHON_USEDEP}]
	dev-python/tld[${PYTHON_USEDEP}]
	dev-python/yaswfp[${PYTHON_USEDEP}]
	kerberos? ( dev-python/requests-kerberos[${PYTHON_USEDEP}] )
	ntlm? ( dev-python/requests-ntlm[${PYTHON_USEDEP}] )"
