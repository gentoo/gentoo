# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyutmp/pyutmp-0.2.1.ebuild,v 1.1 2015/06/19 06:41:26 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python UTMP wrapper for Un*x systems"
HOMEPAGE="https://pypi.python.org/pypi/pyutmp http://bmc.github.com/pyutmp/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""
