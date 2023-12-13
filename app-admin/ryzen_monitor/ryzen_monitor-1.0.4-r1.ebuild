# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

SRC_URI="https://github.com/hattedsquirrel/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 x86"

DESCRIPTION="Monitor power information of Ryzen processors via the PM table of the SMU"
HOMEPAGE="https://github.com/hattedsquirrel/ryzen_monitor"

SLOT="0"
LICENSE="AGPL-3"

RDEPEND="app-admin/ryzen_smu"

PATCHES=(
	"${FILESDIR}"/fix-Makefile.patch
)

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin src/ryzen_monitor
}
