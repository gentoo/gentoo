# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="manage ssh and GPG keys in a convenient and secure manner"
HOMEPAGE="http://www.funtoo.org/Keychain"
SRC_URI="https://github.com/funtoo/keychain/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-posix-sh.patch
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc ChangeLog README.md
}
