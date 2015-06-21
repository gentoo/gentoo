# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/mailx-support/mailx-support-20060102-r2.ebuild,v 1.3 2015/06/21 17:12:26 blueness Exp $

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="Provides lockspool utility"
HOMEPAGE="http://www.openbsd.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND=""
DEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-respect-ldflags.patch
	epatch "${FILESDIR}"/${P}-add-sys_file_h.patch

	# This code should only be ran with Gentoo Prefix profiles
	if use prefix; then
		ebegin "Allowing unprivileged install"
		sed -i -e "s|-g 0 -o 0||g" Makefile
		eend $?
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" BINDNOW_FLAGS="" || die "emake failed"
}

src_install() {
	emake prefix="${D}/usr" install
}
