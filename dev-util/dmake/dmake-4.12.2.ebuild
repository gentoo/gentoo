# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Improved make"
HOMEPAGE="https://github.com/mohawk2/dmake"
SRC_URI="http://${PN}.apache-extras.org.codespot.com/files/${P}.tar.bz2"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

# test failure, reported upstream at
# https://code.google.com/a/apache-extras.org/p/dmake/issues/detail?id=1
RESTRICT="test"

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
