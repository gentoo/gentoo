# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils toolchain-funcs multilib-minimal

DESCRIPTION="Utilities and libraries for NUMA systems"
HOMEPAGE="http://oss.sgi.com/projects/libnuma/"
SRC_URI="ftp://oss.sgi.com/www/projects/libnuma/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
# ARM lacks the __NR_migrate_pages syscall.
KEYWORDS="amd64 -arm ia64 ~mips ppc ppc64 x86 ~amd64-linux"
IUSE=""

ECONF_SOURCE=${S}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.0.8-cpuid-pic.patch #456238
	epatch "${FILESDIR}"/${PN}-2.0.10-numademo-cflags.patch #540856
	epatch "${FILESDIR}"/${PN}-2.0.11-sysmacros.patch #580098
	eautoreconf
	# We need to copy the sources or else tests will fail
	multilib_copy_sources
}

multilib_src_test() {
	if multilib_is_native_abi ; then
		if [ -d /sys/devices/system/node ]; then
			einfo "The only generically safe test is regress2."
			einfo "The other test cases require 2 NUMA nodes."
			emake regress2
		else
			ewarn "You do not have baseline NUMA support in your kernel, skipping tests."
		fi
	fi
}

multilib_src_compile() {
	multilib_is_native_abi && default || emake libnuma.la
}

multilib_src_install() {
	emake DESTDIR="${D}" install$(multilib_is_native_abi || echo "-libLTLIBRARIES install-includeHEADERS")
}

multilib_src_install_all() {
	DOCS=( README TODO CHANGES DESIGN )
	einstalldocs
	# delete man pages provided by the man-pages package #238805
	rm -r "${ED}"/usr/share/man/man[25] || die
}
