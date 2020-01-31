# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit distutils-r1

DESCRIPTION="A VPN command-line tool from protonvpn - python rewrite"
HOMEPAGE="(
https://protonvpn.com
https://github.com/ProtonVPN/protonvpn-cli-ng
)"
SRC_URI="https://github.com/ProtonVPN/${PN}-ng/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT=0

RDEPEND="${PYTHON_DEPS}
	dev-python/setuptools
	dev-python/docopt
	dev-python/requests
	dev-python/pythondialog:0
	net-vpn/openvpn"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-ng-${PV}"

DOCS=( CHANGELOG.md README.md USAGE.md )
