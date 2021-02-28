# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A VPN command-line tool from protonvpn - python rewrite"
HOMEPAGE="https://protonvpn.com https://github.com/ProtonVPN/protonvpn-cli-ng"
SRC_URI="https://github.com/ProtonVPN/linux-cli/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/pythondialog:0[${PYTHON_USEDEP}]
	net-vpn/openvpn"
DEPEND="${RDEPEND}"

S="${WORKDIR}/linux-cli-${PV}"

DOCS=( CHANGELOG.md README.md USAGE.md )
