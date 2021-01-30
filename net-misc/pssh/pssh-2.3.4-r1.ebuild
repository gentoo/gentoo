# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="PSSH provides parallel versions of OpenSSH and related tools"
HOMEPAGE="https://github.com/lilydjwg/pssh"
SRC_URI="https://github.com/lilydjwg/pssh/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="net-misc/openssh
		!net-misc/putty"
DEPEND="${RDEPEND}"

# Requires ssh access to run.
RESTRICT="test"

pkg_setup() {
	python-single-r1_pkg_setup
}

python_prepare_all() {
	sed -i -e "s|man/man1'|share/&|g" setup.py || die
	distutils-r1_python_prepare_all
}
