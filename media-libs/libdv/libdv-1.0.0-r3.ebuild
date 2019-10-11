# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit epatch epunt-cxx libtool ltprune flag-o-matic multilib-minimal

DESCRIPTION="Software codec for dv-format video (camcorders etc)"
HOMEPAGE="http://libdv.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/${PN}-1.0.0-pic.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="static-libs"

RDEPEND="dev-libs/popt"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog INSTALL NEWS TODO )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.99-2.6.patch
	epatch "${WORKDIR}"/${PN}-1.0.0-pic.patch
	elibtoolize
	epunt_cxx #74497

	append-cppflags "-I${S}"
}

multilib_src_configure() {
	ECONF_SOURCE="${S}"	econf \
		$(use_enable static-libs static) \
		--without-debug \
		--disable-gtk \
		--disable-gtktest
	if ! multilib_is_native_abi ; then
		sed -i \
			-e 's/ encodedv//' \
			Makefile || die
	fi
}

multilib_src_install_all() {
	prune_libtool_files --all
	einstalldocs
}
