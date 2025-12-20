# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools qmake-utils

DESCRIPTION="Application and libary for hinting TrueType fonts"
HOMEPAGE="https://freetype.org/ttfautohint"
SRC_URI="https://download.savannah.gnu.org/releases/freetype/${P}.tar.gz"

LICENSE="|| ( FTL GPL-2+ )"
SLOT="0/1.0.3"
KEYWORDS="amd64"
IUSE=""

RDEPEND="
	media-libs/freetype
	media-libs/harfbuzz:=[truetype]
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/help2man
	virtual/pkgconfig
"

# libttfautohint is versioned separately, check lib/local.mk.
QA_PKGCONFIG_VERSION="1.3.0"

src_prepare() {
	default

	# Don't invoke git to get the version number.
	sed "s|m4_esyscmd.*VERSION)|${PV//_/-}|" -i configure.ac || die

	# musl does not define _Bool for c++, bug #836426
	sed 's/_Bool/bool/' -i lib/llrb.h || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--without-doc
		--without-qt # Qt5-based as of 1.8.4 and git master 2025-12-13
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	doman frontend/ttfautohint.1

	find "${ED}" -name '*.la' -delete || die
}
