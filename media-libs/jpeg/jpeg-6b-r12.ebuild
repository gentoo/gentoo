# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/jpeg/jpeg-6b-r12.ebuild,v 1.4 2014/06/09 23:22:38 vapier Exp $

EAPI=5

# this ebuild is only for the libjpeg.so.62 SONAME for ABI compat

PATCH_VER=1
inherit eutils libtool toolchain-funcs multilib-minimal

DESCRIPTION="library to load, handle and manipulate images in the JPEG format (transition package)"
HOMEPAGE="http://www.ijg.org/"
SRC_URI="mirror://gentoo/jpegsrc.v${PV}.tar.gz
	http://dev.gentoo.org/~ssuominen/${P}-patchset-${PATCH_VER}.tar.xz"

LICENSE="IJG"
SLOT="62"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 m68k ~mips ~ppc ~ppc64 s390 sh ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

DOCS=""

RDEPEND="!>=media-libs/libjpeg-turbo-1.3.0-r2:0
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-baselibs-20130224-r5
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}"

src_prepare() {
	EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patch
	epatch "${FILESDIR}"/${PN}-8d-CVE-2013-6629.patch
	elibtoolize
}

multilib_src_configure() {
	tc-export CC
	ECONF_SOURCE=${S} \
	econf \
		--enable-shared \
		--disable-static \
		--enable-maxmem=64
}

multilib_src_compile() {
	emake libjpeg.la
}

multilib_src_install() {
	newlib.so .libs/libjpeg.so.62.0.0 libjpeg.so.62
}
