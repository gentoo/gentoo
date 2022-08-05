# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A simple portage wrapper which works like other package managers"
HOMEPAGE="https://github.com/jdhore/epkg"
SRC_URI="https://github.com/jdhore/${PN}/archive/refs/tags/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="app-portage/eix
	app-portage/gentoolkit
	sys-apps/portage"

S="${WORKDIR}"/${PN}-${P}

src_install() {
	dobin epkg
	doman doc/epkg.1
}
