# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/numactl/numactl-2.0.10.ebuild,v 1.2 2014/11/12 14:56:05 jlec Exp $

EAPI=5

inherit autotools eutils toolchain-funcs multilib

DESCRIPTION="Utilities and libraries for NUMA systems"
HOMEPAGE="http://oss.sgi.com/projects/libnuma/"
SRC_URI="ftp://oss.sgi.com/www/projects/libnuma/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
# ARM lacks the __NR_migrate_pages syscall.
KEYWORDS="~amd64 -arm ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux"
IUSE=""

src_prepare() {
	eautoreconf
	epatch "${FILESDIR}"/${PN}-2.0.8-cpuid-pic.patch #456238
}

src_test() {
	if [ -d /sys/devices/system/node ]; then
		einfo "The only generically safe test is regress2."
		einfo "The other test cases require 2 NUMA nodes."
		emake regress2
	else
		ewarn "You do not have baseline NUMA support in your kernel, skipping tests."
	fi
}

src_install() {
	DOCS=( README TODO CHANGES DESIGN )
	default
	# delete man pages provided by the man-pages package #238805
	rm -r "${ED}"/usr/share/man/man[25] || die
}
