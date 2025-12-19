# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A POSIX shell function to treat a variable like an array, quoting args"
HOMEPAGE="https://github.com/vaeth/push/"
SRC_URI="
	https://github.com/vaeth/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

src_compile() { :; }

src_install() {
	insinto /usr/share/${PN}
	doins bin/push.sh
	dodoc README.md
}
