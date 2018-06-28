# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="base32 encoder/decoder (not RFC 3548 compliant)"
HOMEPAGE="https://pypi.org/project/zbase32/"
SRC_URI="mirror://pypi/z/zbase32/zbase32-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/pyutil[${PYTHON_USEDEP}]"
