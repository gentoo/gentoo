# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit autotools eutils

DESCRIPTION="NVIDIA Overclocking Utility"
HOMEPAGE="http://www.linuxhardware.org/nvclock/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="gtk nvcontrol"

RDEPEND="
	gtk? (
		x11-libs/gtk+:2
		x11-libs/libX11
	)
	nvcontrol? ( x11-libs/libX11 x11-libs/libXext )
"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-r1-make.patch \
		"${FILESDIR}"/${P}-usleep.patch \
		"${FILESDIR}"/${P}-desktop.patch \
		"${FILESDIR}"/${P}-buffers.patch
	eautoreconf
}

src_configure() {
	sed -i \
		-e "/^AR=ar/s:=.*:=$(tc-getAR):" \
		src/*/Makefile.in || die

	# Qt support would mean Qt 3.
	econf \
		--docdir=/usr/share/doc/${PF} \
		--disable-qt \
		$(use_enable gtk) \
		$(use_enable nvcontrol)
}

src_compile() {
	emake -C src/ nvclock smartdimmer
	use gtk && emake -C src/gtk/
}

src_install() {
	mkdir -p "${D}"/usr/bin || die

	default

	newinitd "${FILESDIR}"/nvclock_initd nvclock
	newconfd "${FILESDIR}"/nvclock_confd nvclock
}

pkg_postinst() {
	elog "To enable card overclocking at startup, edit your /etc/conf.d/nvclock"
	elog "accordingly and then run: rc-update add nvclock default"
}
