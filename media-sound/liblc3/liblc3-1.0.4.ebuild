# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="LC3 is an efficient low latency audio codec"
HOMEPAGE="https://github.com/google/liblc3"
SRC_URI="https://github.com/google/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="tools"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~sparc x86"

src_configure() {
	local emesonargs=(
		# We let users choose to enable LTO
		-Db_lto=false
		$(meson_use tools)
	)
	meson_src_configure
}
