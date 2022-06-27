# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A script that can grow your rootfs on first boot"
HOMEPAGE="http://manpages.ubuntu.com/manpages/natty/man1/growpart.1.html"
SRC_URI="https://dev.gentoo.org/~prometheanfire/dist/${PN}/${P}.gz"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~riscv x86"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/gptfdisk"

src_install() {
	exeinto /usr/sbin/
	newexe "growpart-${PV}" growpart
}
