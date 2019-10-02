# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Automatically restart SSH sessions and tunnels"
HOMEPAGE="https://www.harding.motd.ca/autossh/"
SRC_URI="https://www.harding.motd.ca/${PN}/${P}.tgz"

LICENSE="BSD"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
SLOT="0"

RDEPEND="net-misc/openssh"

src_install() {
	dobin autossh
	dodoc CHANGES README autossh.host rscreen
	doman autossh.1
}
