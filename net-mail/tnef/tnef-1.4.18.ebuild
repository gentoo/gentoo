# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="Decodes MS-TNEF MIME attachments"
HOMEPAGE="https://github.com/verdammelt/tnef/"
SRC_URI="https://github.com/verdammelt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~hppa ppc ppc64 ~sparc x86"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# bug #943831
	append-flags -std=gnu17

	default
}

src_test() {
	emake -j1 check
}
