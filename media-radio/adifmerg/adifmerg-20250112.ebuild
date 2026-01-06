# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A small conversion and check utility for ADIF files"
HOMEPAGE="https://github.com/oh7bf/adifmerg"

COMMIT="4b5dec2c9437e2b7a9a31a97f80c11216f8790d2"
SRC_URI="https://github.com/oh7bf/adifmerg/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="examples"

RDEPEND="dev-lang/perl"

src_install() {
	dobin adifmerg
	doman doc/adifmerg.1
	dodoc CHANGELOG README.md

	if use examples; then
		insinto /usr/share/${PN}
		doins -r script
	fi
}
