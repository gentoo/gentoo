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
KEYWORDS="~alpha amd64 ~arm ~ia64 ppc x86"
IUSE="selinux"

DEPEND="dev-libs/libgcrypt:0
	dev-libs/libgpg-error"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-rngd )"

src_prepare() {
	echo 'bin_PROGRAMS = randstat' >> contrib/Makefile.am
	epatch "${FILESDIR}"/test-for-argp.patch\
		"${FILESDIR}"/${P}-fix-textrels-on-PIC-x86.patch
	eautoreconf

	sed -i '/^AR /d' Makefile.in || die
	tc-export AR
}

src_install() {
	default
	newinitd "${FILESDIR}"/rngd-initd-4.1 rngd
	newconfd "${FILESDIR}"/rngd-confd-4.1 rngd
	systemd_dounit "${FILESDIR}"/rngd.service
}
