# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

DESCRIPTION="Wraps the chroot command while ensuring that important filesystems are mounted"
HOMEPAGE="https://github.com/archlinux/arch-install-scripts"
SRC_URI="https://github.com/archlinux/arch-install-scripts/archive/refs/tags/v${PV}.tar.gz -> arch-install-scripts-v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

BDEPEND="app-text/asciidoc"

S="${WORKDIR}/arch-install-scripts-${PV}"

src_compile() {
	emake MANS="doc/arch-chroot.8" BINPROGS="arch-chroot"
}

src_test() {
	emake MANS="doc/arch-chroot.8" BINPROGS="arch-chroot" check
}

src_install() {
	dobin arch-chroot
	doman doc/arch-chroot.8
	newbashcomp "completion/arch-chroot.bash" "arch-chroot"
}
