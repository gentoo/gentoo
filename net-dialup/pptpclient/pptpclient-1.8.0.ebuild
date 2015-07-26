# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/pptpclient/pptpclient-1.8.0.ebuild,v 1.5 2015/07/23 21:02:52 pacho Exp $

EAPI="5"

inherit eutils toolchain-funcs

MY_P="${P/client}"
MY_CMD="pptp-command-20130515"

DESCRIPTION="Linux client for PPTP"
HOMEPAGE="http://pptpclient.sourceforge.net/"
SRC_URI="mirror://sourceforge/pptpclient/${MY_P}.tar.gz
	http://dev.gentoo.org/~pinkbyte/distfiles/pptpclient/${MY_CMD}.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~arm ppc ~ppc64 x86"
IUSE="tk"

DEPEND="net-dialup/ppp
	dev-lang/perl
	tk? ( dev-perl/perl-tk )"
RDEPEND="${DEPEND}
	sys-apps/iproute2"

RESTRICT="test" #make test is useless and vector_test.c is broken

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS ChangeLog DEVELOPERS NEWS README TODO USING )

src_prepare() {
	epatch "${FILESDIR}"/${P}-process-name.patch
	epatch_user
}

src_compile() {
	emake OPTIMISE= DEBUG= CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	default
	dodoc Documentation/*
	dodir /etc/pptp.d

	# The current version of pptp-linux doesn't include the
	# RH-specific portions, so include them ourselves.
	newsbin "${WORKDIR}/${MY_CMD}" pptp-command
	dosbin "${FILESDIR}/pptp_fe.pl"
	use tk && dosbin "${FILESDIR}/xpptp_fe.pl"
}
