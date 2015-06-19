# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/txt2man/txt2man-1.5.6.ebuild,v 1.11 2015/05/14 14:51:27 jmorgan Exp $

EAPI="4"

DESCRIPTION="Scripts to convert regular ASCII text to man pages"
HOMEPAGE="http://mvertes.free.fr/"
SRC_URI="http://mvertes.free.fr/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE=""

RDEPEND="app-shells/bash
	sys-apps/gawk"

src_compile() { :; }

src_install() {
	dobin bookman src2man txt2man
	doman *.1
	dodoc Changelog README
}
