# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN="MoarVM"

DESCRIPTION="A 6model-based VM for NQP and Raku"
HOMEPAGE="http://moarvm.org
	https://github.com/MoarVM/MoarVM"
SRC_URI="http://moarvm.org/releases/${MY_PN}-${PV}.tar.gz"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="asan debug +jit optimize static-libs ubsan"
# Tests are conducted in dev-lang/nqp ebuild
RESTRICT="test"

RDEPEND="
	dev-libs/libatomic_ops
	>=dev-libs/libuv-1.26:=
	dev-libs/libffi:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
"
S="${WORKDIR}/${MY_PN}-${PV}"

DOCS="CREDITS README.markdown docs/*"

src_configure() {
	local prefix="${EPREFIX}/usr"
	local libdir="${EPREFIX}/usr/$(get_libdir)"
	case "$(tc-get-compiler-type)" in
		gcc)
			local compiler=gcc;;
		clang)
			local compiler=clang;;
		*)
			die "tc-get-compiler-type should return either gcc or clang."
	esac
	local myconfigargs=(
		"--prefix" "${prefix}"
		"--has-libuv"
		"--has-libatomic_ops"
		"--has-libffi"
		"--libdir" "${libdir}"
		"--compiler" "${compiler}"
		"$(usex jit "" "--no-jit")"
		"$(usex asan        --asan)"
		"$(usex debug       --debug            --no-debug)"
		"$(usex optimize    --optimize=        --no-optimize)"
		"$(usex static-libs --static)"
		"$(usex ubsan       --ubsan)"
	)

	perl Configure.pl "${myconfigargs[@]}" moarshared || die
}

src_compile() {
	emake NOISY=1 || die "emake failed"
}
