# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/slowaes/slowaes-0.1-r1.ebuild,v 1.5 2015/07/05 22:30:25 blueness Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

MY_P=${P}a1
DESCRIPTION="AES implementation in pure Python"
HOMEPAGE="http://code.google.com/p/slowaes/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPENDS="dev-python/setuptools"

S=${WORKDIR}/${MY_P}
