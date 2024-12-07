# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Web interface for airdcpp-webclient"
HOMEPAGE="https://airdcpp-web.github.io/"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="=net-p2p/airdcpp-webclient-${PV%.*}*"

src_install() {
	insinto "/usr/share/airdcpp/web-resources"
	doins -r dist/.
}
