# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Combines up to 8 audio mono wave ch. into one big multi ch. wave file"
HOMEPAGE="https://www.panteltje.nl/panteltje/dvd/index.html"
SRC_URI="https://www.panteltje.nl/panteltje/dvd/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

PATCHES=( "${FILESDIR}"/${PN}-0.2.4-makefiles.patch )

src_configure() {
	append-lfs-flags
	tc-export CC
}

src_install() {
	dobin multimux
	einstalldocs
}
