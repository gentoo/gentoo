# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Agent manager for OpenSSH, ssh.com, Sun SSH, and GnuPG"
HOMEPAGE="https://www.funtoo.org/Keychain"
SRC_URI="https://github.com/funtoo/keychain/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

BDEPEND="dev-lang/perl"

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc ChangeLog README.md
}
