# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic

MY_PN="MoarVM"
if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/${MY_PN}/${MY_PN}.git"
	inherit git-r3
	KEYWORDS=""
	S="${WORKDIR}/${P}"
else
	SRC_URI="https://moarvm.org/releases/${MY_PN}-${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="A 6model-based VM for NQP and Rakudo Perl 6"
HOMEPAGE="http://moarvm.org"
LICENSE="Artistic-2"
SLOT="0"
IUSE="asan clang debug doc +jit static-libs +system-libs optimize ubsan"

RDEPEND="dev-libs/libatomic_ops
		dev-libs/libtommath
		dev-libs/libuv
		jit? ( dev-lang/lua:0[deprecated]
			dev-lua/LuaBitOp )
		virtual/libffi"
DEPEND="${RDEPEND}
	clang? ( >=sys-devel/clang-3.1 )
	dev-lang/perl"

PATCHES=( "${FILESDIR}/Configure-2016.04.patch" )
DOCS=( CREDITS README.markdown )

# Tests are conducted via nqp
RESTRICT=test

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
		"$(usex optimize    --optimize=        --no-optimize)"
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
