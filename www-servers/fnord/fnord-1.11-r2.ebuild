# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Yet another small httpd"
HOMEPAGE="http://www.fefe.de/fnord/"
SRC_URI="http://www.fefe.de/fnord/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~riscv sparc x86"
IUSE="auth"

RDEPEND="
	acct-group/nofiles
	acct-user/fnord
	acct-user/fnordlog
	sys-apps/ucspi-tcp
	virtual/daemontools
"

DOCS=( TODO README README.auth SPEED CHANGES )

PATCHES=( "${FILESDIR}/${PN}"-1.10-gentoo.diff )

src_compile() {
	# Fix for bug #45716
	use sparc && replace-sparc64-flags
	use auth && append-flags -DAUTH

	emake DIET="" CC=$(tc-getCC) CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin fnord-conf fnord
	einstalldocs
}
