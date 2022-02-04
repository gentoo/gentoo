# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Genfstab - generate output suitable for addition to an fstab file"
HOMEPAGE="https://github.com/scardracs/genfstab https://man.archlinux.org/man/genfstab.8"
SRC_URI="https://github.com/scardracs/genfstab/releases/download/${PV}/${P}.tar.gz"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

BDEPEND="app-text/asciidoc"
