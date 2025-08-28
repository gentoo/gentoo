# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/yoranheling.asc

ZIG_SLOT="0.14"
ZIG_NEEDS_LLVM=1
inherit verify-sig zig

DESCRIPTION="NCurses Disk Usage"
HOMEPAGE="https://dev.yorhel.nl/ncdu https://code.blicky.net/yorhel/ncdu"
SRC_URI="
	https://dev.yorhel.nl/download/${P}.tar.gz
	verify-sig? ( https://dev.yorhel.nl/download/${P}.tar.gz.asc )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-yorhel )"
DEPEND="
	app-arch/zstd:=
	sys-libs/ncurses:=[unicode(+)]
"
RDEPEND="${DEPEND}"

DOCS=( "README.md" "ChangeLog" )

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.gz{,.asc}
	fi
	zig_src_unpack
}

src_configure() {
	local my_zbs_args=(
		-Dpie=true
		# Upstream recommends this default:
		--release=fast
	)

	zig_src_configure
}

src_install() {
	zig_src_install

	doman ncdu.1
}
