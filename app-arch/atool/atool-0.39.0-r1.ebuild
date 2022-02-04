# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Script for managing file archives of various types"
HOMEPAGE="https://www.nongnu.org/atool/"
SRC_URI="https://savannah.nongnu.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	!app-text/adiff"

PATCHES=(
	"${FILESDIR}"/${PN}-0.39.0-configure-bashism.patch
)

src_prepare() {
	default

	# Needed for the bashism patch
	eautoreconf
}
