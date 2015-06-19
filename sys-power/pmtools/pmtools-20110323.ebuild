# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/pmtools/pmtools-20110323.ebuild,v 1.1 2011/04/03 03:58:56 nerdboy Exp $

EAPI=2

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="ACPI disassembler tools, including acpidump"
HOMEPAGE="http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/"
SRC_URI="http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/utils/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
DEPEND=""
RDEPEND="${DEPEND}
		dev-lang/perl
		>=sys-power/iasl-20090521"

S="${WORKDIR}/pmtools"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-20100123-acpixtract-pmtools.patch
	epatch "${FILESDIR}"/${PN}-20100123-madt.patch
	epatch "${FILESDIR}"/${PN}-20071116-64bit.patch
	epatch "${FILESDIR}"/${PN}-20101124-cflags-ldflags.patch

	# update version info
	sed -i -e "s|20060324|20110323|" acpixtract/acpixtract.c

	strip-unsupported-flags
}

src_compile() {
	# respect user's LDFLAGS
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	# acpidump access the ACPI data via /dev/mem or EFI firmware in /sys
	dosbin acpidump/acpidump
	# the other tools only process data
	newbin acpixtract/acpixtract acpixtract-pmtools
	dobin madt/madt
	dosbin turbostat/turbostat
	doman turbostat/turbostat.8

	dodoc README
	docinto madt
	dodoc madt/README
	use doc && dodoc madt/APIC*
}

pkg_postinst() {
	ewarn "Please note that acpixtract is now named acpixtract-pmtools to avoid"
	ewarn "conflicts with the new tool of the same name from the iasl package."
}
