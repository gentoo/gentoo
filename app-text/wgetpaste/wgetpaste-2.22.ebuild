# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/wgetpaste/wgetpaste-2.22.ebuild,v 1.9 2014/09/14 15:32:19 mrueg Exp $

EAPI="4"

DESCRIPTION="Command-line interface to various pastebins"
HOMEPAGE="http://wgetpaste.zlin.dk/"
SRC_URI="http://wgetpaste.zlin.dk/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="zsh-completion +lodgeit-default"

DEPEND=""
RDEPEND="net-misc/wget
	zsh-completion? ( app-shells/zsh )"

src_prepare() {
	sed -i -e "s:/etc:\"${EPREFIX}\"/etc:g" wgetpaste || die
}

src_install() {
	dobin ${PN}
	insinto /etc/wgetpaste.d
	newins "${FILESDIR}"/wgetpaste-config-services services.conf
	use lodgeit-default && \
		newins "${FILESDIR}"/wgetpaste-config-default-lodgeit gentoo-default.conf
	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		doins _wgetpaste
	fi
}
