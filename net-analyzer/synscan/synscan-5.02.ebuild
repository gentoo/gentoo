# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A fast asynchronous half-open TCP portscanner"
HOMEPAGE="http://www.digit-labs.org/files/tools/synscan/"
SRC_URI="http://www.digit-labs.org/files/tools/${PN}/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x64-macos"
IUSE="kernel_Darwin kernel_FreeBSD kernel_linux kernel_SunOS"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-destdir.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	eautoreconf
}

src_compile() {
	local _target

	use kernel_FreeBSD && _target=freebsd
	use kernel_linux && _target=linux
	use kernel_SunOS && _target=solaris-sparc-gcc
	use kernel_Darwin && _target=macos

	emake ${_target}
}
