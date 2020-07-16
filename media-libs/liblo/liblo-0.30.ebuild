# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Lightweight OSC (Open Sound Control) implementation"
HOMEPAGE="https://sourceforge.net/projects/liblo/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~ppc-macos"
IUSE="doc ipv6 static-libs"

RESTRICT="test"

BDEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	default

	# don't build examples by default
	sed -i '/^SUBDIRS =/s/examples//' Makefile.am || die

	eautoreconf
}

src_configure() {
	use doc || export ac_cv_prog_HAVE_DOXYGEN=false

	# switching threads on/off breaks ABI, bugs #473282, #473286 and #473356
	myeconfargs=(
		--enable-threads
		$(use_enable ipv6)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
}
