# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic eutils

DESCRIPTION="Atari Running on Any Machine, a VM running Atari ST/TT/Falcon OS and TOS/GEM applications"
HOMEPAGE="http://aranym.sourceforge.net/"
SRC_URI="mirror://sourceforge/aranym/${P/-/_}.orig.tar.gz
	mirror://sourceforge/aranym/afros812.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="+fullmmu +lilo opengl usbhost X"

RDEPEND="games-emulation/emutos
	media-libs/libsdl
	opengl? ( virtual/opengl )
	X? ( media-libs/libsdl[X] )"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_configure() {
	filter-flags -mpowerpc-gfxopt

	local myconf=""
	if [[ ${ARCH} == x86 ]]; then
		myconf="${myconf} --enable-jit-compiler"
	fi

	if ! use X; then
		myconf="${myconf} --disable-nfjpeg --disable-nfclipbrd"
	fi

	econf \
		$(use_enable X gui) \
		$(use_enable opengl) \
		$(use_enable fullmmu) \
		$(use_enable lilo) \
		$(use_enable usbhost) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" INSTALL_PROGRAM="install" install

	insinto /usr/share/${PN}
	doins -r "${WORKDIR}"/afros

	dodoc "${D}"/usr/share/doc/${PN}/*
	rm -r "${D}"/usr/share/doc/${PN} || die
}

pkg_postinst() {
	elog "To run ARAnyM with AFROS type: aranym --config /usr/share/aranym/afros/config"
}
