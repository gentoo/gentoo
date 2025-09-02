# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Emulates the detach feature of screen"
HOMEPAGE="http://dtach.sourceforge.net/ https://github.com/crigler/dtach"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9-c23.patch
)

src_install() {
	dobin dtach
	doman dtach.1
	einstalldocs
}
