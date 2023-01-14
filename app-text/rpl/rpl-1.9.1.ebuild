# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="Intelligent recursive search/replace utility"
HOMEPAGE="http://rpl.sourceforge.net/ https://github.com/rrthomas/rpl"
SRC_URI="https://github.com/rrthomas/rpl/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="dev-python/chardet[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	dev-python/argparse-manpage[${PYTHON_USEDEP}]
	sys-apps/help2man[nls]
"

python_compile_all() {
	# Compile man file
	emake rpl.1
}
