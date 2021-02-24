# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Low and high level wrappers around the GSSAPI C libraries"
HOMEPAGE="https://github.com/pythongssapi/python-gssapi https://pypi.org/project/gssapi/"
SRC_URI="mirror://pypi/g/gssapi/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="test"

RDEPEND="virtual/krb5"
DEPEND="${RDEPEND}
dev-python/decorator[${PYTHON_USEDEP}]"
