# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="simple GnuPG-encrypted password store written in perl"
HOMEPAGE="http://roland.entierement.nu/blog/2010/01/22/simple-gnupg-encrypted-password-store.html"
SRC_URI="http://dev.gentoo.org/~flameeyes/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="zsh-completion"

RDEPEND="app-crypt/gnupg
	dev-lang/perl
	virtual/perl-Storable
	virtual/perl-File-Temp
	virtual/perl-Getopt-Long
	dev-perl/Config-Simple
	zsh-completion? ( app-shells/zsh )"
DEPEND=""

S="${WORKDIR}"

src_install() {
	dobin sgeps pwsafe2sgeps
	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		newins zsh-completion _sgeps
	fi
}

pkg_postinst() {
	elog "To make use of sgeps, remember to create a configuration file as"
	elog " ~/.config/sgeps.conf with these values:"
	elog ""
	elog "store = ~/somewhere/safe"
	elog "keyid = 012345678"
	elog ""
	elog "If you want to use the --copy options you should install x11-misc/xclip"
}
