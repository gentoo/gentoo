# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SMU_PN="ryzen_smu"
SMU_PV="0.1.5"
inherit toolchain-funcs

DESCRIPTION="Monitor power information of Ryzen processors via the PM table of the SMU"
HOMEPAGE="https://github.com/hattedsquirrel/ryzen_monitor"
SRC_URI="
	https://github.com/hattedsquirrel/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://gitlab.com/leogx9r/${SMU_PN}/-/archive/v${SMU_PV}/${SMU_PN}-v${SMU_PV}.tar.bz2
"

LICENSE="AGPL-3 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-admin/ryzen_smu"

src_unpack() {
	unpack "${P}.tar.gz" "${SMU_PN}-v${SMU_PV}.tar.bz2"
}

src_prepare() {
	rm "src/lib/"* || die
	cp -a "${WORKDIR}/${SMU_PN}-v${SMU_PV}/lib/libsmu."{c,h} "src/lib/" || die

	default
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin src/ryzen_monitor
}
