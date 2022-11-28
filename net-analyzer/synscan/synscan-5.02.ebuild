# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Fast asynchronous half-open TCP portscanner"
HOMEPAGE="http://www.digit-labs.org/files/tools/synscan/"
SRC_URI="http://www.digit-labs.org/files/tools/synscan/releases/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86 ~x64-macos"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-destdir.patch
	"${FILESDIR}"/${P}-lld.patch
)

src_prepare() {
	default

	eautoreconf
}

src_compile() {
	local _target

	use kernel_linux && _target=linux
	use kernel_SunOS && _target=solaris-sparc-gcc
	use kernel_Darwin && _target=macos

	emake ${_target}
}
