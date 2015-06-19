# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/zbase32/zbase32-1.1.5.ebuild,v 1.4 2015/04/08 08:05:29 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="base32 encoder/decoder (not RFC 3548 compliant)"
HOMEPAGE="http://pypi.python.org/pypi/zbase32"
SRC_URI="mirror://pypi/z/zbase32/zbase32-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/pyutil[${PYTHON_USEDEP}]"
