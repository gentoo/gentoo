# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libao/libao-1.1.0-r2.ebuild,v 1.2 2014/06/18 19:38:18 mgorny Exp $

EAPI=5

inherit libtool multilib multilib-minimal eutils

DESCRIPTION="The Audio Output library"
HOMEPAGE="http://www.xiph.org/ao/"
SRC_URI="http://downloads.xiph.org/releases/ao/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="alsa nas mmap pulseaudio static-libs"

RDEPEND="alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	nas? ( >=media-libs/nas-1.9.4[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-sound/pulseaudio-2.1-r1[${MULTILIB_USEDEP}] )
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20131008-r1
		!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i -e 's:-O20::' configure || die
	sed -i -e "s:/lib:/$(get_libdir):g" ao.m4 || die
	elibtoolize
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		$(use_enable static-libs static) \
		--disable-esd \
		$(use_enable alsa alsa) \
		$(use_enable mmap alsa-mmap) \
		--disable-arts \
		$(use_enable nas) \
		$(use_enable pulseaudio pulse)
}

multilib_src_install() {
	emake DESTDIR="${D}" docdir="${EPREFIX}/usr/share/doc/${PF}/html" install
}

multilib_src_install_all() {
	dodoc AUTHORS CHANGES README TODO
	prune_libtool_files --all
}
