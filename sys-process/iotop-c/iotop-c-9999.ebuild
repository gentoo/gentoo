# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/Tomas-M/iotop"
inherit fcaps git-r3 linux-info toolchain-funcs

DESCRIPTION="top utility for IO (C port)"
HOMEPAGE="https://github.com/Tomas-M/iotop"

LICENSE="GPL-2+"
SLOT="0"

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
