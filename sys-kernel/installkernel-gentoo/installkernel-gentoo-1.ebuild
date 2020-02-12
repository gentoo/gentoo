# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Gentoo fork of installkernel script from debianutils"
HOMEPAGE="https://github.com/mgorny/installkernel-gentoo"
SRC_URI="https://github.com/mgorny/installkernel-gentoo/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~x86-linux"

RDEPEND="
	>=sys-apps/debianutils-4.9-r1
	!<sys-apps/debianutils-4.9-r1[installkernel(+)]
	!sys-kernel/installkernel-systemd-boot"

src_install() {
	into /
	dosbin installkernel
	doman installkernel.8
	keepdir /etc/kernel/postinst.d
}
