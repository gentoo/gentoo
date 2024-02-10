# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="library to smooth charset/localization issues"
HOMEPAGE="http://natspec.sourceforge.net/"
SRC_URI="mirror://sourceforge/natspec/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="doc"

RDEPEND="dev-libs/popt"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-text/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.6-iconv.patch
	"${FILESDIR}"/${PN}-0.3.0-bashisms.patch
	"${FILESDIR}"/${PN}-0.3.0-doxygen.patch
)

src_prepare() {
	default
	# regenerate to fix incompatible readlink usage
	eautoreconf
}

src_configure() {
	# braindead configure script does not disable python on --without-python
	econf $(use_with doc doxygen)
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
