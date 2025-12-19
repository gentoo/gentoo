# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SCOTT
DIST_VERSION=1.5
inherit perl-module

DESCRIPTION="Try every conceivable way to get full hostname"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~mips ppc ppc64 ~riscv ~sparc x86"

src_install() {
	perl-module_src_install
	rm "${ED}${VENDOR_LIB}"/Sys/Hostname/testall.pl || die
	dodoc testall.pl
	docompress -x /usr/share/doc/${PF}/testall.pl
}
