# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/configparser/configparser-3.3.0.2.ebuild,v 1.4 2015/06/13 01:20:34 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )
inherit distutils-r1

MY_PV=${PV%.*}r${PV##*.}
DESCRIPTION="Backport of Python-3 built-in configparser"
HOMEPAGE="http://pypi.python.org/pypi/configparser/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PN}-${MY_PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}/${PN}-${MY_PV}
