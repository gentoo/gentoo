# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Library for sci-biology/mauve"
HOMEPAGE="http://gel.ahabs.wisc.edu/mauve/"
SRC_URI="mirror://gentoo/${P}-r1.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

RDEPEND="!sci-biology/muscle"
BDEPEND="doc? ( app-text/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PV}-bufferoverflow.patch
	"${FILESDIR}"/${PN}-3.7-fix-build-system.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/862897
	# Upstream website doesn't load. Nowhere to report bugs to.
	#
	# Do not trust with LTO either.
	append-flags -fno-strict-aliasing
	filter-lto

	econf $(use_enable static-libs static)
}

src_install() {
	default

	# package provides .pc file
	find "${D}" -name '*.la' -delete || die
}
