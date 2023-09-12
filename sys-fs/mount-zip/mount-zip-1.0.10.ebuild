# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="FUSE file system for ZIP archives"
HOMEPAGE="https://github.com/google/mount-zip"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	dev-libs/icu:=
	dev-libs/libzip:=
	sys-fs/fuse:0=
"

DEPEND="
	${RDEPEND}
	dev-libs/boost
"

BDEPEND="
	virtual/pkgconfig
"

DOCS=( changelog README.md )

src_install() {
	default
	doman mount-zip.1
}
