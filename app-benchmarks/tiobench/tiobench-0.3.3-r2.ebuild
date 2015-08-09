# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="Portable, robust, fully-threaded I/O benchmark program"
HOMEPAGE="http://tiobench.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ppc ppc64"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PV}-column-description-fix.patch
	epatch "${FILESDIR}"/${PV}-LDFLAGS.patch
	epatch "${FILESDIR}"/${PV}-glibc-2.16.patch

	sed -i \
		-e 's:/usr/local/bin:/usr/sbin:' tiobench.pl \
		|| die "sed tiobench.pl failed"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LINK="$(tc-getCC)" \
		DEFINES="-DLARGEFILES" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	dosbin tiotest tiobench.pl tiosum.pl || die "dosbin failed"
	dodoc BUGS ChangeLog README TODO || die "dodoc failed"
}
