# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

MY_PV=$(ver_rs 1- _)

DESCRIPTION="A console ICQ client supporting versions 7/8"
HOMEPAGE="http://ysmv7.sourceforge.net/"
SRC_URI="mirror://sourceforge/ysmv7/${PN}v7_${MY_PV}.tar.bz2"
S="${WORKDIR}"/${PN}v7_${MY_PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
RESTRICT="mirror"

# Introduced by fix-configure.patch
BDEPEND="dev-build/autoconf-archive"

PATCHES=(
	"${FILESDIR}"/${PN}-2.9.9.1-dont-strip-binary.patch
	"${FILESDIR}"/${PN}-2.9.9.1-fix-bashism.patch
	"${FILESDIR}"/${PN}-2.9.9.1-fix-configure.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die

	# Made obsolete by rewrite patch (fix-configure.patch)
	rm aclocal.m4 || die

	config_rpath_update .
	eautoreconf
}

src_configure() {
	# fix bug #570408 by restoring pre-GCC 5 inline semantics
	append-cflags -std=gnu89

	econf
}
