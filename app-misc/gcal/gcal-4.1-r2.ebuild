# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="The GNU Calendar - a replacement for cal"
HOMEPAGE="https://www.gnu.org/software/gcal/"
SRC_URI="mirror://gnu/gcal/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="ncurses nls unicode"

RDEPEND="nls? ( virtual/libintl )
	unicode? ( dev-libs/libunistring:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	nls? ( >=sys-devel/gettext-0.17 )
"

DOCS=( BUGS LIMITATIONS NEWS README THANKS TODO )

PATCHES=(
	"${FILESDIR}/${P}-glibc228.patch"
	"${FILESDIR}/${PN}-4.1-configure-clang16.patch"
	"${FILESDIR}/${P}-fortify.patch"
)

src_prepare() {
	default

	# Drop once ${PN}-4.1-configure-clang16.patch merged
	eautoreconf
}

src_configure() {
	tc-export CC
	append-cppflags -D_GNU_SOURCE

	use unicode && append-libs -lunistring

	econf \
		--disable-rpath \
		$(use_enable nls) \
		$(use_enable ncurses term) \
		$(use_enable unicode)
}

src_test() {
	default

	# Do basic smoke tests to help catch issues like bug #925560
	# where trivial 'gcal' invocation crashed w/ _F_S=3.
	local bin
	for bin in gcal2txt tcal txt2gcal gcal ; do
		src/${bin} || die
	done
}
