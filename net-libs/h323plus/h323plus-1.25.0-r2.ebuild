# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic multilib toolchain-funcs

MY_P="${PN}-v${PV//./_}"

DESCRIPTION="Open Source implementation of the ITU H.323 teleconferencing protocol, successor to OpenH323"
HOMEPAGE="http://www.h323plus.org/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-v${PV//./_}.tar.gz"

IUSE="aec debug +sound +video"
SLOT="0/${PV}"
LICENSE="MPL-1.1"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~sparc ~x86"

DEPEND=">=net-libs/ptlib-2.6.4:=[-debug,wav]
	aec? ( >=media-libs/speex-1.2_rc1 )
	sound? (
		media-sound/gsm
		dev-libs/ilbc-rfc3951
	)
	video? (
		media-libs/libtheora
		virtual/ffmpeg
	)
	net-nds/openldap
	dev-libs/openssl:0="
RDEPEND="${DEPEND}
	!net-libs/openh323"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.25.0-ptrace-param.patch
	epatch "${FILESDIR}"/${PN}-1.25.0-ptrace-debugoptionlist.patch
	epatch "${FILESDIR}"/${PN}-1.25.0-ptlib-2.10.10.patch
}

src_configure() {
	# TODO: support for h.263/h.264/sbc(bluetooth)/celt/spandsp
	#export OPENH323DIR=${S}
	econf \
		PTLIB_CONFIG="${EPREFIX}/usr/bin/ptlib-config" \
		$(use_enable video) \
		$(use_enable sound audio) \
		$(use_enable aec) \
		$(use_enable debug asntracing)
	# revision.h does not exist in ptlib(?)
	sed -i "/revision.h/d" include/openh323buildopts.h || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)"
	# these should point to the right directories,
	# openh323.org apps and others need this
	sed -i -e "s:^OH323_LIBDIR = \$(OPENH323DIR).*:OH323_LIBDIR = /usr/$(get_libdir):" \
		openh323u.mak || die
	sed -i -e "s:^OH323_INCDIR = \$(OPENH323DIR).*:OH323_INCDIR = /usr/include/openh323:" \
		openh323u.mak || die
	# this is hardcoded now?
	sed -i -e "s:^\(OPENH323DIR[ \t]\+=\) "${S}":\1 /usr/share/openh323:" \
		openh323u.mak || die
}
