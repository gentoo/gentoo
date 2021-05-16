# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Improved make"
HOMEPAGE="https://jimjag.github.io/dmake/"
SRC_URI="https://github.com/jimjag/${PN}/archive/v${PV}/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

BDEPEND="
	app-arch/unzip
	sys-apps/groff"

src_prepare() {
	default

	# make tests executable, bug #404989
	chmod +x tests/targets-{1..12} || die
}

src_install() {
	default
	newman man/dmake.tf dmake.1
}
