# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="easy-to-use, pythonic, and complete IMAP client library"
HOMEPAGE="https://github.com/mjs/imapclient"
SRC_URI="https://github.com/mjs/imapclient/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.0-ssl-context.patch
)

distutils_enable_sphinx doc/src
distutils_enable_tests unittest

python_install_all() {
	distutils-r1_python_install_all
	use examples && dodoc -r examples
}
