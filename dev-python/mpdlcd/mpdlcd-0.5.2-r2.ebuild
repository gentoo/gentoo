# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="A small tool to display the MPD status on a LCDproc server"
HOMEPAGE="https://github.com/rbarrois/mpdlcd"
SRC_URI="https://github.com/rbarrois/${PN}/archive/refs/tags/${P}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/python-mpd"

distutils_enable_tests pytest

src_prepare() {
	default

	# Fix QA 'The license_file parameter is deprecated, use license_files instead.'
	sed -e 's/license_file/license_files/g' -i setup.cfg || die
}

python_install_all() {
	distutils-r1_python_install_all

	doman man/mpdlcd.1

	insinto /etc
	doins mpdlcd.conf

	newinitd "${FILESDIR}"/mpdlcd.initd mpdlcd
	newconfd "${FILESDIR}"/mpdlcd.confd mpdlcd
}
