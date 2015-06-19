# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/wapiti/wapiti-9999.ebuild,v 1.2 2015/04/08 18:01:22 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='xml'

ESVN_REPO_URI="http://svn.code.sourceforge.net/p/wapiti/code/trunk/"
inherit distutils-r1 subversion

DESCRIPTION="Web-application vulnerability scanner"
HOMEPAGE="http://wapiti.sourceforge.net/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	>=dev-python/requests-1.2.3[${PYTHON_USEDEP}]"
