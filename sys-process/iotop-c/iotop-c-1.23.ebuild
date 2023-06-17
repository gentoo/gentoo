# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps linux-info toolchain-funcs

DESCRIPTION="top utility for IO (C port)"
HOMEPAGE="https://github.com/Tomas-M/iotop"
SRC_URI="https://github.com/Tomas-M/iotop/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/iotop-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong x86"

RDEPEND="sys-libs/ncurses:=
	!sys-process/iotop"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

CONFIG_CHECK="~TASK_IO_ACCOUNTING ~TASK_DELAY_ACCT ~TASKSTATS ~VM_EVENT_COUNTERS"

FILECAPS=(
	cap_net_admin=eip usr/bin/iotop
)

src_compile() {
	emake V=1 CC="$(tc-getCC)" PKG_CONFIG="$(tc-getPKG_CONFIG)" NO_FLTO=1
}

src_install() {
	dobin iotop
	dodoc README.md
	doman iotop.8
}
