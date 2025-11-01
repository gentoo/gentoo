# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit plasma.kde.org

DESCRIPTION="Breeze theme for GRUB"

LICENSE="GPL-3+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE=""

src_prepare() { default; }
src_configure() { :; }
src_compile() { :; }

src_install() {
	insinto /usr/share/grub/themes
	doins -r breeze
}
