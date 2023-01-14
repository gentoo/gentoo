# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="SIPVicious is a SIP security package"
HOMEPAGE="https://github.com/EnableSecurity/sipvicious/wiki"
SRC_URI="https://github.com/EnableSecurity/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="$(python_gen_cond_dep '
		dev-python/dnspython[${PYTHON_USEDEP}]
		dev-python/reportlab[${PYTHON_USEDEP}]
	')"

src_prepare() {
	default
	sed -re 's:man/man1:share/man/man1:' -i setup.py || die "Error updating man page installation location."
}
