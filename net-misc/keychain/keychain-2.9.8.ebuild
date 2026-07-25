# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

DESCRIPTION="Agent manager for OpenSSH, ssh.com, Sun SSH, and GnuPG"
HOMEPAGE="https://github.com/danielrobbins/keychain"
SRC_URI="https://github.com/danielrobbins/keychain/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

BDEPEND="dev-lang/perl"

PATCHES=(
	# Patches from Debian
	"${FILESDIR}/${PN}-2.9.8-empty-ssh-askpass.patch"
)

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc ChangeLog.md README.md
	newbashcomp completions/keychain.bash ${PN}
}
