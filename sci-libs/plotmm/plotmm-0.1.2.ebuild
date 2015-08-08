# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils

DESCRIPTION="Plot widget for GTKmm"
HOMEPAGE="http://plotmm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="doc examples"

RDEPEND="dev-cpp/gtkmm:2.4"
DEPEND="${RDEPEND}
		virtual/pkgconfig"

# NOTES:
# somewhat, there is a dep on libsigc++ but it's much more via gtkmm

src_prepare() {
	epatch "${FILESDIR}/${P}-libsigc++-2.2.patch"

	if ! use examples; then
		sed -i -e "s:examples::" Makefile.in || die "sed failed"
	fi
}

src_configure() {
	econf \
		--disable-maintainer-mode \
		--disable-dependency-tracking \
		--enable-fast-install \
		--disable-libtool-lock
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"

	if use doc; then
		dohtml -r doc/html/* || die "dohtml failed"
	fi

	if use examples; then
		# rename installed bin files
		mv "${D}"/usr/bin/curves "${D}"/usr/bin/${PN}-curves || die "mv failed"
		mv "${D}"/usr/bin/simple "${D}"/usr/bin/${PN}-simple || die "mv failed"

		# install sources
		insinto /usr/share/doc/${PF}/examples/
		doins examples/{curves/curves,simple/simple}.cc || die "doins failed"

		elog "You can use examples by calling ${PN}-curves or ${PN}-simple."
		elog "Examples source code is in /usr/share/doc/${PF}/examples."
	fi
}
