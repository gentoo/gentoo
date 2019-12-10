# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools

DESCRIPTION="A collection of powerful tools for manipulating EPROM load files"
HOMEPAGE="http://srecord.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/libgcrypt:0"
DEPEND="${RDEPEND}
	dev-libs/boost
	sys-apps/groff
	test? ( app-arch/sharutils )"

PATCHES=( "${FILESDIR}"/${PN}-1.57-libtool.patch )

src_prepare() {
	default

	cp etc/configure.ac "${S}"
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
