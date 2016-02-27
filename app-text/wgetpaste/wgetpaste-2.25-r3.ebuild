# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="Command-line interface to various pastebins"
HOMEPAGE="http://wgetpaste.zlin.dk/"
SRC_URI="http://wgetpaste.zlin.dk/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND="net-misc/wget"

src_prepare() {
	sed -i -e "s:/etc:\"${EPREFIX}\"/etc:g" wgetpaste || die
	epatch "${FILESDIR}"/wgetpaste-2.25-pinnwand.patch
	epatch "${FILESDIR}"/wgetpaste-2.25-pinnwand-raw.patch
}

src_install() {
	dobin ${PN}
	insinto /etc/wgetpaste.d
	newins "${FILESDIR}"/wgetpaste-config-services services.conf
	insinto /usr/share/zsh/site-functions
	doins _wgetpaste
}
