# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Agent manager for OpenSSH, ssh.com, Sun SSH, and GnuPG"
HOMEPAGE="https://github.com/danielrobbins/keychain"
SRC_URI="https://github.com/danielrobbins/keychain/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

BDEPEND="dev-lang/perl"

PATCHES=(
	# Patches from Debian
	"${FILESDIR}/${P}-malformed-ssh-key.patch"
	"${FILESDIR}/${P}-typos.patch"
	"${FILESDIR}/${P}-empty-ssh-askpass.patch"
)

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc ChangeLog README.md
}
