# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# svn export http://svn.xiph.org/trunk/Tremor tremor-${PV}

inherit autotools eutils multilib-minimal

DESCRIPTION="A fixed-point version of the Ogg Vorbis decoder (also known as libvorbisidec)"
HOMEPAGE="http://wiki.xiph.org/Tremor"
SRC_URI="https://dev.gentoo.org/~ssuominen/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd"
IUSE="low-accuracy static-libs"

RDEPEND=">=media-libs/libogg-1.3.0:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( "CHANGELOG" "README" )

src_prepare() {
	sed -i \
		-e '/CFLAGS/s:-O2::' \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		configure.in || die

	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		$(use_enable low-accuracy)
}

multilib_src_install_all() {
	einstalldocs
	dohtml -r doc/*
	prune_libtool_files
}
