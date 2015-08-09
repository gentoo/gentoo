# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils prefix

DESCRIPTION="Password generator capable of generating pronounceable and/or secure passwords"
HOMEPAGE="http://mackers.com/misc/scripts/passook/"
# snapshot of git://github.com/mackers/passook.git
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="dev-lang/perl
	sys-apps/miscfiles"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/passook.patch
	eprefixify passook
}

src_install() {
	dobin passook
	dodoc README passook.cgi
}
