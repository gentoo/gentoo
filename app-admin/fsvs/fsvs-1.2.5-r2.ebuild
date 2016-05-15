# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Backup/restore for subversion backends"
HOMEPAGE="http://fsvs.tigris.org/"
SRC_URI="http://download.fsvs-software.org/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-vcs/subversion
	dev-libs/libpcre
	sys-libs/gdbm
	dev-libs/apr-util
	dev-util/ctags"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-as-needed.patch"
)

src_prepare() {
	# fix #570596 by restoring pre-GCC5 inline semantics
	append-cflags -std=gnu89
	default
}

src_compile() {
	# respect compiler
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin src/fsvs
	dodir /etc/fsvs
	keepdir /var/spool/fsvs
	doman doc/*5 doc/*1
	dodoc doc/{FAQ,IGNORING,PERFORMANCE,USAGE}
}

pkg_postinst() {
	elog "Remember, this system works best when you're connecting to a remote"
	elog "svn server."
	elog
	elog "Go to the base path for versioning:"
	elog "    cd /"
	elog "Tell fsvs which URL it should use:"
	elog "    fsvs url svn+ssh://username@machine/path/to/repos"
	elog "Define ignore patterns - all virtual filesystems (/proc, /sys, etc.),"
	elog "and (assuming that you're in / currently) the temporary files in /tmp:"
	elog "    fsvs ignore DEVICE:0 ./tmp/*"
	elog "And you're ready to play!"
	elog "Check your data in:"
	elog "    fsvs commit -m \"First import\""
}
