# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Optimally generate PCF files from BDF files"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

# these apps are used at runtime by ebdftopcf
RDEPEND="
	app-arch/gzip
	x11-apps/bdftopcf"

src_install() {
	insinto /usr/share/ebdftopcf
	doins Makefile.ebdftopcf
	dodoc README
}
