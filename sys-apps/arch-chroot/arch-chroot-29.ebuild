# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion

DESCRIPTION="Wraps the chroot command while ensuring that important filesystems are mounted"
HOMEPAGE="https://gitlab.archlinux.org/archlinux/arch-install-scripts"
SRC_URI="https://gitlab.archlinux.org/archlinux/arch-install-scripts/-/archive/v${PV}/arch-install-scripts-v${PV}.tar.bz2"

S="${WORKDIR}/arch-install-scripts-v${PV}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="app-text/asciidoc"

src_compile() {
	emake MANS="doc/arch-chroot.8" BINPROGS="arch-chroot"
}

src_test() {
	emake MANS="doc/arch-chroot.8" BINPROGS="arch-chroot" check
}

src_install() {
	dobin arch-chroot
	doman doc/arch-chroot.8
	newbashcomp completion/bash/arch-chroot arch-chroot
	newzshcomp completion/zsh/_arch-chroot _arch-chroot
}
