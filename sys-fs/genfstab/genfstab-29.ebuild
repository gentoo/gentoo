# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion

DESCRIPTION="Genfstab - generate output suitable for addition to an fstab file"
HOMEPAGE="https://gitlab.archlinux.org/archlinux/arch-install-scripts https://man.archlinux.org/man/genfstab.8"
SRC_URI="https://gitlab.archlinux.org/archlinux/arch-install-scripts/-/archive/v${PV}/arch-install-scripts-v${PV}.tar.bz2"

S="${WORKDIR}/arch-install-scripts-v${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	app-alternatives/awk
	app-text/asciidoc
	sys-devel/m4
"

src_test() {
	emake MANS="doc/genfstab.8" BINPROGS="genfstab" check
}

src_compile() {
	emake MANS="doc/genfstab.8" BINPROGS="genfstab"
}

src_install() {
	dobin genfstab
	doman doc/genfstab.8
	newbashcomp completion/bash/genfstab genfstab
	newzshcomp completion/zsh/_genfstab _genfstab
}
