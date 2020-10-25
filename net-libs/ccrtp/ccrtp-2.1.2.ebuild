# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="GNU ccRTP - Implementation of the IETF real-time transport protocol"
HOMEPAGE="https://www.gnu.org/software/ccrtp/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/2"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs debug demos doc"

RDEPEND="
	>=dev-libs/libgcrypt-1.2.3
	>=dev-libs/ucommon-6.3.1[cxx]"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_prepare() {
	if ! use doc; then
		sed -ie '/^SUBDIRS.*=/s#doc##' Makefile.am || die "sed failed"
		sed -ie 's#^doc/Makefile.##' configure.ac || die "sed failed"
	fi

	einfo "Regenerating autotools files..."
	eautoconf
	eautomake
	eapply_user
}

src_configure() {
	econf --enable-static=$(usex static-libs) $(use_enable debug) $(use_enable demos)
}

src_install() {
	default

	find "${ED}" -name '*.la' -type f -delete || die

	if use demos; then
		dodir "/usr/share/${PN}"
		dodir "/usr/share/${PN}/.libs"
		find "${S}/demo" -exec test -x {} \; -exec cp {} "${D}/usr/share/${PN}" \;
		find "${S}/demo/.libs" -exec test -x {} \; -exec cp {} "${D}/usr/share/${PN}/.libs" \;
	fi

	if use doc; then
		dodoc -r doc/html/
	fi
}
