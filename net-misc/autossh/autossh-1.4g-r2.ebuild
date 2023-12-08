# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Automatically restart SSH sessions and tunnels"
HOMEPAGE="https://www.harding.motd.ca/autossh/"
SRC_URI="https://www.harding.motd.ca/${PN}/${P}.tgz"

LICENSE="BSD"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
SLOT="0"

DEPEND="dev-libs/libbsd"
RDEPEND="${DEPEND}
	virtual/openssh"

PATCHES=(
	"${FILESDIR}"/autossh-1.4g-libbsd.patch
	"${FILESDIR}"/autossh-1.4g-printf.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	dobin autossh
	dodoc CHANGES README autossh.host rscreen
	doman autossh.1
}
