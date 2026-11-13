# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Zero-dependency C library for parsing terminal sequences and managing state"
HOMEPAGE="https://lib.ghostty.org/vt/"

# Keep in sync with deps/libghostty-vt.txt and deps/packages.json of the release tarball.
declare -g -r -A ZBS_DEPENDENCIES=(
	[aro-0.0.0-JSD1QtuBNwCASyBtNF3pqTl_W3oAJQGEVyFAtrBSE_Pa.tar.gz]='https://deps.files.ghostty.org/aro-d0c8c4d9c55daa7ef6e40cf0f630a5b5e900989b.tar.gz'
	[N-V-__8AAGmZhABbsPJLfbqrh6JTHsXhY6qCaLAQyx25e0XE.tar.gz]='https://deps.files.ghostty.org/highway-66486a10623fa0d72fe91260f96c892e41aceb06.tar.gz'
	[translate_c-2.0.0-Q_BUWltOBwBYABF84EUL208pIFeUIwbBs29FmVBaafN5.tar.gz]='https://deps.files.ghostty.org/translate_c-02ff0c523fb92a38939b04d0145c4a9602a74d56.tar.gz'
	[uucode-0.2.0-ZZjBPm6FVgBcY-79AHV8ckQj86z0JwOyVyj89VeZrEiv.tar.gz]='https://deps.files.ghostty.org/uucode-1fb73433bba5d93366c57f23ff2e9d7939746500.tar.gz'
	[N-V-__8AAP5JWgCGP_AD0teWpa4krRvE9VPZzvviGdbmN4jI.tar.gz]='https://deps.files.ghostty.org/wuffs-7411f488fe2e2c205c3d3b3d28638b7356522930.tar.gz'
)

ZIG_SLOT="0.17"
ZIG_NEEDS_LLVM=1
inherit zig

SRC_URI="https://github.com/ghostty-org/ghostty/archive/refs/tags/vt-${PV}.tar.gz -> ${P}.tar.gz
	${ZBS_DEPENDENCIES_SRC_URI}
"
S="${WORKDIR}/ghostty-vt-${PV}"

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="~amd64"
IUSE="static-libs"
RESTRICT="test"

RDEPEND="!<x11-terms/ghostty-1.4.0-r1"

src_configure() {
	local my_zbs_args=(
		--release=fast
		-Demit-lib-vt=true
		-Dapp-runtime=none
		-Dsimd=true
		-Dlib-version-string="${PV}"
		-Dstrip=false
	)

	zig_src_configure
}

src_install() {
	zig_src_install

	if ! use static-libs; then
		rm -f "${ED}"/usr/lib*/libghostty-vt.a \
			"${ED}"/usr/lib*/pkgconfig/libghostty-vt-static.pc || die
	fi
}
