# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A small tool to display the MPD status on a LCDproc server."
HOMEPAGE="https://github.com/rbarrois/mpdlcd"
SRC_URI="https://github.com/rbarrois/${PN}/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/python-mpd"

S="${WORKDIR}/${PN}-${P}"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all

	doman man/mpdlcd.1

	insinto /etc
	doins mpdlcd.conf

	newinitd "${FILESDIR}"/mpdlcd.initd mpdlcd
	newconfd "${FILESDIR}"/mpdlcd.confd mpdlcd
}
