# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Expanded md5sum program with recursive and comparison options"
HOMEPAGE="http://md5deep.sourceforge.net/"
SRC_URI="https://github.com/jessek/hashdeep/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/hashdeep-release-${PV}"

LICENSE="public-domain GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~mips ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"

PATCHES=( "${FILESDIR}"/${PN}-4.4-pointer-comparison.patch )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	dodoc FILEFORMAT
}
