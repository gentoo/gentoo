# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs user

DESCRIPTION="Yet another small httpd"
HOMEPAGE="http://www.fefe.de/fnord/"
SRC_URI="http://www.fefe.de/fnord/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 hppa ppc sparc x86"
IUSE="auth"

DEPEND=""
RDEPEND="${DEPEND}
	virtual/daemontools
	sys-apps/ucspi-tcp"

DOCS=( TODO README README.auth SPEED CHANGES )
PATCHES=( "${FILESDIR}/${PN}"-1.10-gentoo.diff )

pkg_setup() {
	enewgroup nofiles 200
	enewuser fnord -1 -1 /etc/fnord nofiles
	enewuser fnordlog -1 -1 /etc/fnord nofiles
}

src_compile() {
	# Fix for bug #45716
	use sparc && replace-sparc64-flags

	use auth && append-flags -DAUTH

	emake DIET="" CC=$(tc-getCC) CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install () {
	dobin fnord-conf fnord
	einstalldocs
}
