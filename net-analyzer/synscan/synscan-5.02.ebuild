# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools eutils

DESCRIPTION="A fast asynchronous half-open TCP portscanner"
HOMEPAGE="http://www.digit-labs.org/files/tools/synscan/"
SRC_URI="http://www.digit-labs.org/files/tools/${PN}/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kernel_FreeBSD kernel_linux"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-destdir.patch"
)

src_prepare() {
	default
	mv "$S"/configure.in "$S"/configure.ac || die
	eautoconf
}

src_configure() {
	econf --prefix="${EPREFIX}"/usr
}

src_compile() {
	local _target
	use kernel_FreeBSD && _target=freebsd
	use kernel_linux && _target=linux

	emake ${_target}
}
