# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Library for communication with TI calculators"
HOMEPAGE="http://lpg.ticalc.org/prj_tilp/"
SRC_URI="https://downloads.sourceforge.net/tilp/tilp2-linux/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc nls static-libs"

RDEPEND="
	dev-libs/glib:2
	>=sci-libs/libticables2-1.3.3
	>=sci-libs/libticonv-1.1.3
	>=sci-libs/libtifiles2-1.1.5
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

DOCS=( AUTHORS LOGO NEWS README ChangeLog docs/api.txt )

PATCHES=(
	# https://github.com/debrouxl/tilibs/pull/87
	"${FILESDIR}"/0001-libticalcs-fix-erroneous-bashism-in-configure-script.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/927586
	filter-lto

	econf \
		--disable-rpath \
		$(use_enable static-libs static) \
		$(use_enable nls)
}

src_install() {
	use doc && HTML_DOCS+=( docs/html/. )
	default
	find "${D}" -name '*.la' -delete || die
}
