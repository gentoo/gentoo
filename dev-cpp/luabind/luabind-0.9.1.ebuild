# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# NOTE: cross compiling is probably broken

EAPI=5

inherit eutils multilib

DESCRIPTION="Creates bindings for lua on c++"
HOMEPAGE="http://www.rasterbar.com/products/luabind.html"
SRC_URI="mirror://sourceforge/luabind/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-lang/lua"
DEPEND="${RDEPEND}
	dev-libs/boost
	dev-util/boost-build"

src_prepare() {
	epatch "${FILESDIR}"/${P}-boost.patch

	# backwardscomapt with old boost-build-1.49.0
	if [[ -e $(which bjam-1_49 2>/dev/null) ]] ; then
		my_bjam_bin=bjam-1_49
	else
		my_bjam_bin=bjam
	fi
}

src_compile() {
	# linkflags get appended, so they actually do nothing
	${my_bjam_bin} release \
		-d+2 \
		--prefix="${D}/usr/" \
		--libdir="${D}/usr/$(get_libdir)" \
		cflags="${CFLAGS}" \
		linkflags="${LDFLAGS}" \
		link=shared || die "compile failed"
}

src_install() {
	${my_bjam_bin} release \
		-d+2 \
		--prefix="${D}/usr/" \
		--libdir="${D}/usr/$(get_libdir)" \
		cflags="${CFLAGS}" \
		linkflags="${LDFLAGS}" \
		link=shared \
		install || die "install failed"
}

# generally, this really sucks, patches welcome
