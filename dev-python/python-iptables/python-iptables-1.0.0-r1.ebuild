# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Python bindings for iptables"
HOMEPAGE="https://github.com/ldx/python-iptables"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="net-firewall/iptables"

# tests manipulate live iptables rules, so disable them by default
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/python-iptables-1.0.0-ldconfig-fix.patch"
)

distutils_enable_sphinx doc
distutils_enable_tests setup.py

python_prepare_all() {
	# Prevent un-needed d'loading during doc build
	sed -e "s/, 'sphinx.ext.intersphinx'//" -i doc/conf.py || die
	distutils-r1_python_prepare_all
}
