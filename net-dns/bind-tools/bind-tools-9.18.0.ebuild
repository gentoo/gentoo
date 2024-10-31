# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="bind tools: dig, nslookup, host, nsupdate, dnssec-keygen"
HOMEPAGE="https://www.isc.org/software/bind https://gitlab.isc.org/isc-projects/bind9"

LICENSE="Apache-2.0 BSD BSD-2 GPL-2 HPND ISC MPL-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="+caps doc gssapi idn libedit readline xml"

RDEPEND=">=net-dns/bind-9.18.0[caps?,doc?,gssapi?,idn?,xml?]"

pkg_postinst() {
	ewarn "net-dns/bind-tools is now merged into net-dns/bind and"
	ewarn "net-dns/bind-tools serves as a dummy package until it is"
	ewarn "eventually removed. The split was already a maintenance burden"
	ewarn "because of lack of build system support for it, but this became"
	ewarn "more severe with >=9.18.0."
	ewarn ""
	ewarn "Please run the following commands:"
	ewarn "* emerge --deselect net-dns/bind-tools"
	ewarn "* emerge --noreplace net-dns/bind instead"
}
