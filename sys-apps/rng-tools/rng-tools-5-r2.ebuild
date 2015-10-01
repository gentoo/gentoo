# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools systemd toolchain-funcs

DESCRIPTION="Daemon to use hardware random number generators"
HOMEPAGE="http://gkernel.sourceforge.net/"
SRC_URI="mirror://sourceforge/gkernel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~x86"
IUSE="selinux"

DEPEND="dev-libs/libgcrypt:0
	dev-libs/libgpg-error"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-rngd )"

src_prepare() {
	echo 'bin_PROGRAMS = randstat' >> contrib/Makefile.am || die
	epatch "${FILESDIR}"/test-for-argp.patch
	epatch "${FILESDIR}"/${P}-fix-textrels-on-PIC-x86.patch #469962
	epatch "${FILESDIR}"/${P}-man-fill-watermark.patch #555094
	epatch "${FILESDIR}"/${P}-man-rng-device.patch #555106
	epatch "${FILESDIR}"/${P}-fix-noctty.patch #556456
	eautoreconf

	sed -i '/^AR /d' Makefile.in || die
	tc-export AR
}

src_install() {
	default
	newinitd "${FILESDIR}"/rngd-initd-r1-4.1 rngd
	newconfd "${FILESDIR}"/rngd-confd-4.1 rngd
	systemd_dounit "${FILESDIR}"/rngd.service
}
