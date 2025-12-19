# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="IP Calculator prints broadcast/network/etc for an IP address and netmask"
HOMEPAGE="http://jodies.de/ipcalc"
SRC_URI="https://github.com/kjokjo/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND=">=dev-lang/perl-5.6.0"

src_prepare() {
	eapply_user
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc changelog contributors README.md
}
