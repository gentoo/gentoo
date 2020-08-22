# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="library to smooth charset/localization issues"
HOMEPAGE="http://natspec.sourceforge.net/"
SRC_URI="mirror://sourceforge/natspec/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86"
IUSE="doc"

RDEPEND="
	dev-libs/popt
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.6-iconv.patch
)

src_prepare() {
	default
	# regenerate to fix imcompatible readlink usage
	rm -f "${S}"/ltmain.sh "${S}"/libtool || die
	eautoreconf
}

src_configure() {
	use doc || export ac_cv_prog_DOX=no
	# braindead configure script does not disable python on --without-python
	econf
}
