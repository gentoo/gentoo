# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="General-purpose library for iRiver's iFP portable audio players"
HOMEPAGE="https://ifp-driver.sourceforge.net/libifp/"
SRC_URI="mirror://sourceforge/ifp-driver/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ia64 ppc ppc64 x86"
IUSE="doc examples static-libs"

RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}
	doc? ( >=app-text/doxygen-1.3.7 )"

src_prepare() {
	default
	sed -i \
		-e '/CFLAGS=/s:-g -O2:${CFLAGS}:' \
		-e '/CXXFLAGS=/s:-g -O2:${CXXFLAGS}:' \
		configure || die
}

src_configure() {
	use doc || export have_doxygen=no

	econf \
		$(use_enable static-libs static) \
		$(use_enable examples) \
		--with-libusb \
		--without-kmodule
}

src_test() { :; } # hardware dependant wrt #318597

src_install() {
	emake DESTDIR="${D}" install

	find "${D}" -name '*.la' -exec rm -f {} + || die

	# clean /usr/bin after installation
	# by moving examples to examples dir
	if use examples; then
	    insinto /usr/share/${PN}/examples
	    doins "${S}"/examples/simple.c "${S}"/examples/ifpline.c
	    mv "${D}"/usr/bin/{simple,ifpline} "${D}"/usr/share/${PN}/examples || die
	else
	    rm -f "${D}"/usr/bin/{simple,ifpline} || die
	fi

	use doc && dodoc README ChangeLog TODO
}
