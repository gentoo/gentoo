# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Lightweight OSC (Open Sound Control) implementation"
HOMEPAGE="https://sourceforge.net/projects/liblo/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~loong ~ppc ~ppc64 ~x86 ~ppc-macos"
IUSE="doc ipv6 static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( app-text/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.31-werror.patch
)

src_prepare() {
	default

	# don't build examples by default
	sed -i '/^SUBDIRS =/s/examples//' Makefile.am || die

	eautoreconf
}

src_configure() {
	use doc || export ac_cv_prog_HAVE_DOXYGEN=false

	# switching threads on/off breaks ABI, bugs #473282, #473286 and #473356
	local myeconfargs=(
		--enable-threads
		--disable-network-tests
		$(use_enable test tests)
		# See README.md note wrt ipv6. Disabled by default upstream
		# because can break Pd and SuperCollider.
		$(use_enable ipv6)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
}
