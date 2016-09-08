# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils multilib python toolchain-funcs

DESCRIPTION="A library to make the use of LV2 plugins as simple as possible for applications"
HOMEPAGE="http://wiki.drobilla.net/SLV2"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc jack"

RDEPEND=">=dev-libs/redland-1.0.6
	jack? ( >=media-sound/jack-audio-connection-kit-0.107.0 )
	|| ( media-libs/lv2 media-libs/lv2core )"
DEPEND="${RDEPEND}
	|| ( dev-lang/python:2.7 dev-lang/python:2.6 )
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/ldconfig.patch
	epatch "${FILESDIR}"/${P}-raptor2-link.patch
}

src_configure() {
	tc-export CC CXX CPP AR RANLIB
	LINKFLAGS="${LDFLAGS}" \
	./waf configure \
		--prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--htmldir=/usr/share/doc/${PF}/html \
		$(use doc && echo --build-docs) \
		$(use jack || echo --no-jack) \
		|| die
}

src_compile() {
	./waf || die
}

src_install() {
	./waf --destdir="${D}" install || die
	dodoc AUTHORS README ChangeLog
}
