# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="SIPVicious is a SIP security package"
HOMEPAGE="https://github.com/EnableSecurity/sipvicious/wiki"
SRC_URI="https://github.com/EnableSecurity/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-3+"
SLOT="0"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="$(python_gen_cond_dep '
		dev-python/dnspython[${PYTHON_USEDEP}]
		dev-python/reportlab[${PYTHON_USEDEP}]
	')"

src_prepare() {
	default
	sed -re 's:man/man1:share/man/man1:' -i setup.py || die "Error updating man page installation location."
}
