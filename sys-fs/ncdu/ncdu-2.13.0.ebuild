# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

declare -r -A ZBS_DEPENDENCIES=(
	[translate_c-2.0.2-Q_BUWvBNBwBgPKQJPblip6M7AHNK_IPNPmyv4rSIQMQc.tar.gz]='https://codeberg.org/ziglang/translate-c/archive/2.0.2.tar.gz'
	[aro-0.0.0-JSD1QvCRNwC2O1Jkop9TO6sXb1U1vhrH8FnYK1VdEMKn.tar.gz]='https://codeberg.org/ziglang/arocc/archive/630d99ed60fe61ccabe721f1af60881f8b2adde3.tar.gz'
)

ZIG_SLOT="0.17"
ZIG_NEEDS_LLVM=1

inherit zig

DESCRIPTION="NCurses Disk Usage"
HOMEPAGE="
	https://ncdu.landless-city.net
	https://github.com/BratishkaErik/ncdu
"
SRC_URI="
	https://github.com/BratishkaErik/ncdu/releases/download/v${PV}/${P}-src.tar.gz
	${ZBS_DEPENDENCIES_SRC_URI}
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="
	app-arch/zstd:=
	sys-libs/ncurses:=[unicode(+)]
"
RDEPEND="${DEPEND}"

DOCS=( "README.md" )

src_configure() {
	local my_zbs_args=(
		-Dpie=true
		# Upstream recommends this default:
		--release=fast

		-fsys=ncurses
		-fsys=zstd
	)

	zig_src_configure
}

src_install() {
	zig_src_install

	doman ncdu.1
}
