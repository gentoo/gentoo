# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-3)
inherit plasma.kde.org

DESCRIPTION="Breeze theme for GRUB"

LICENSE="GPL-3+"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv"
IUSE=""

src_prepare() { default; }
src_configure() { :; }
src_compile() { :; }

src_install() {
	insinto /usr/share/grub/themes
	doins -r breeze
}
