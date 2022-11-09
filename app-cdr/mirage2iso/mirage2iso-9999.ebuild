# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools git-r3

DESCRIPTION="CD/DVD image converter using libmirage"
HOMEPAGE="https://github.com/mgorny/mirage2iso/"
EGIT_REPO_URI="https://github.com/mgorny/mirage2iso.git"

LICENSE="BSD"
SLOT="0"
IUSE="pinentry test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/libmirage-2.0.0:0=
	dev-libs/glib:2=
	pinentry? ( dev-libs/libassuan:0= )"
RDEPEND="${DEPEND}
	pinentry? ( app-crypt/pinentry )"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with pinentry libassuan)
}
