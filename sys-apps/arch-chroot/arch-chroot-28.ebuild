# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Generate output suitable for addition to an fstab file"
HOMEPAGE="https://github.com/archlinux/arch-install-scripts"
SRC_URI="https://github.com/archlinux/arch-install-scripts/archive/refs/tags/v${PV}.tar.gz -> arch-install-scripts-v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/arch-install-scripts-${PV}"

src_compile() {
	emake MANS="doc/arch-chroot.8" BINPROGS="arch-chroot"
}

src_install() {
	dobin arch-chroot
}
