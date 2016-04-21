# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils flag-o-matic multilib

MY_PN="MoarVM"

DESCRIPTION="A 6model-based VM for NQP and Rakudo Perl 6"
HOMEPAGE="http://moarvm.org"
SRC_URI="http://moarvm.org/releases/${MY_PN}-${PV}.tar.gz"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="asan clang debug doc +jit static-libs +system-libs optimize ubsan"

RDEPEND="system-libs? ( dev-libs/libatomic_ops
		dev-libs/libtommath
		dev-libs/libuv
		jit? ( dev-lang/lua[deprecated]
			dev-lua/LuaBitOp )
		virtual/libffi )
		"
DEPEND="${RDEPEND}
	clang? ( >=sys-devel/clang-3.1 )
	dev-lang/perl
	dev-perl/extutils-pkgconfig"

REQUIRED_USE="asan? ( clang )"
S="${WORKDIR}/MoarVM-${PV}"
PATCHES=( "${FILESDIR}/Configure-${PV}.patch" )
DOCS=( CREDITS README.markdown )

src_prepare() {
	eapply "${PATCHES[@]}"
	eapply_user
	use doc && DOCS+=( docs/* )
}

src_configure() {
	local myconfigargs=(
		"--prefix=/usr"
		"--libdir=$(get_libdir)"
		"--compiler=$(usex clang clang gcc)"
		"$(usex asan        --asan)"
		"$(usex debug       --debug            --no-debug)"
		"$(usex jit         --lua=/usr/bin/lua --no-jit)"
		"$(usex optimize    --optimize         --no-optimize)"
		"$(usex static-libs --static)"
		"$(usex system-libs --has-libtommath)"
		"$(usex system-libs --has-libuv)"
		"$(usex system-libs --has-libatomic_ops)"
		"$(usex system-libs --has-libffi)"
		"$(usex ubsan       --ubsan)"
	)
	use optimize && filter-flags '-O*'

	perl Configure.pl "${myconfigargs[@]}" || die
}
