# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/yoranheling.asc
# Upstream states 0.12.x and 0.13.x support,
# but eclass supports only one slot.
ZIG_SLOT="0.13"
inherit verify-sig zig-build

DESCRIPTION="NCurses Disk Usage"
HOMEPAGE="https://dev.yorhel.nl/ncdu"
SRC_URI="
	https://dev.yorhel.nl/download/${P}.tar.gz
	verify-sig? ( https://dev.yorhel.nl/download/${P}.tar.gz.asc )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-yorhel )"
DEPEND="sys-libs/ncurses:=[unicode(+)]"
RDEPEND="${DEPEND}"

DOCS=( "README.md" "ChangeLog" )

src_unpack() {
	verify-sig_src_unpack
}

src_configure() {
	local my_zbs_args=(
		-Dpie=true
	)

	zig-build_src_configure
}

src_install() {
	zig-build_src_install

	doman ncdu.1
}
