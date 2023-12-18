# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

DESCRIPTION="Genfstab - generate output suitable for addition to an fstab file"
HOMEPAGE="https://github.com/archlinux/arch-install-scripts https://man.archlinux.org/man/genfstab.8"
SRC_URI="https://github.com/archlinux/arch-install-scripts/archive/refs/tags/v${PV}.tar.gz -> arch-install-scripts-v${PV}.tar.gz"

S="${WORKDIR}/arch-install-scripts-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong x86"
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
	newbashcomp completion/genfstab.bash genfstab
}
