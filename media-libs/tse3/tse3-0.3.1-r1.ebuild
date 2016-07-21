# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit autotools eutils flag-o-matic

DESCRIPTION="TSE3 Sequencer library"
HOMEPAGE="http://TSE3.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/${P}-awe_voice.h.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="alsa oss"

RDEPEND="alsa? ( media-libs/alsa-lib )"
DEPEND="${RDEPEND}"

src_prepare() {
	if use oss; then
		cp "${WORKDIR}"/awe_voice.h src/
		append-flags -DHAVE_AWE_VOICE_H
	fi

	epatch "${FILESDIR}"/${PN}-0.2.7-size_t-64bit.patch \
		"${FILESDIR}"/${PN}-0.2.7-gcc4.patch \
		"${FILESDIR}"/${P}-parallelmake.patch \
		"${FILESDIR}"/${P}+gcc-4.3.patch

	eautoreconf
}

src_configure() {
	local myconf

	use alsa || myconf="${myconf} --without-alsa"
	use oss || myconf="${myconf} --without-oss"

	econf \
		--without-doc-install \
		--without-aRts \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README THANKS TODO doc/History
	dohtml doc/*.{html,gif,png}
}
