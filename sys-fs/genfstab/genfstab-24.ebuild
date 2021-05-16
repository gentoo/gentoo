# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Genfstab - generate output suitable for addition to an fstab file"
HOMEPAGE="https://github.com/scardracs/genfstab.git https://man.archlinux.org/man/genfstab.8"
SRC_URI="https://github.com/scardracs/${PN}/releases/download/${PV}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"

S="${WORKDIR}"

BDEPEND="app-text/asciidoc"
