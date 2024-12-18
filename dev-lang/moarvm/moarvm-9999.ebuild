# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo

MY_PN="MoarVM"
if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/${MY_PN}/${MY_PN}.git"
	inherit git-r3
else
	SRC_URI="http://moarvm.org/releases/${MY_PN}-${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="A 6model-based VM for NQP and Raku"
HOMEPAGE="http://moarvm.org"

LICENSE="Artistic-2"
SLOT="0"
IUSE="asan clang debug doc +jit optimize static-libs ubsan"
# Tests are conducted via nqp
RESTRICT=test

RDEPEND="
	app-arch/zstd:=
	dev-libs/libatomic_ops
	>=dev-libs/libuv-1.26:=
	dev-libs/libffi:=
"
DEPEND="${RDEPEND}
	dev-lang/perl
	clang? ( >=llvm-core/clang-3.1 )
"

DOCS=( CREDITS README.markdown )

src_configure() {
	MAKEOPTS+=" NOISY=1"
	use doc && DOCS+=( docs/* )
	local myconfigargs=(
		"--prefix" "${EPREFIX}/usr"
		"--has-libuv"
		"--has-libatomic_ops"
		"--has-libffi"
		"--libdir"   "${EPREFIX}/usr/$(get_libdir)"
		"--compiler" "$(usex clang clang gcc)"
		"$(usex asan        --asan        "")"
		"$(usex debug       --debug       --no-debug)"
		"$(usex optimize    --optimize=   --no-optimize)"
		"$(usex static-libs --static      "")"
		"$(usex ubsan       --ubsan       "")"
	)

	edo perl Configure.pl "${myconfigargs[@]}" moarshared
}
