# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pysendfile/pysendfile-2.0.1.ebuild,v 1.2 2015/07/18 11:52:34 zlogene Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="A python interface to sendfile(2) system call"
HOMEPAGE="http://code.google.com/p/pysendfile/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="amd64 ~x86"
IUSE=""
LICENSE="MIT"
SLOT="0"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# Testsuite abandonned due to demanding starting a local web type server
