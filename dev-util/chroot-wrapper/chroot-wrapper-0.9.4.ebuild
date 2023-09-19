# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info

DESCRIPTION="Wrapper for chroot to set up some bind mounts, namespaces, and control groups"
HOMEPAGE="https://github.com/chutz/chroot-wrapper"
SRC_URI="https://github.com/chutz/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=app-shells/bash-5.0
	sys-apps/util-linux
	sys-apps/coreutils
"

CONFIG_CHECK="
	~TMPFS
	~IPC_NS
	~UTS_NS
"

src_install() {
	newsbin src/chroot-wrapper chr
	insinto /etc/chroot-wrapper
	doins config.bash
}
