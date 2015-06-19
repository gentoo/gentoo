# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/keychain/keychain-2.7.1-r2.ebuild,v 1.1 2015/03/20 09:24:36 hwoarang Exp $

EAPI=5

inherit eutils

DESCRIPTION="manage ssh and GPG keys in a convenient and secure manner. Frontend for ssh-agent/ssh-add"
HOMEPAGE="http://www.funtoo.org/wiki/Keychain"
SRC_URI="http://www.funtoo.org/archive/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND="app-shells/bash
	virtual/ssh"

src_prepare() {
	epatch "${FILESDIR}"/${P}-openssh-6.8.patch
}

src_compile() { :; }

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc ChangeLog README.rst
}
