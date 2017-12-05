# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/mgorny/mirage2iso.git"
inherit autotools git-r3

DESCRIPTION="CD/DVD image converter using libmirage"
HOMEPAGE="https://github.com/mgorny/mirage2iso/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="pinentry test"

COMMON_DEPEND=">=dev-libs/libmirage-2.0.0:0=
	dev-libs/glib:2=
	pinentry? ( dev-libs/libassuan:0= )"
DEPEND="${COMMON_DEPEND}
	dev-libs/libassuan
	virtual/pkgconfig
	test? ( app-arch/xz-utils )"
RDEPEND="${COMMON_DEPEND}
	pinentry? ( app-crypt/pinentry )"

RESTRICT="!test? ( test )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_with pinentry libassuan)
	)

	econf "${myconf[@]}"
}
