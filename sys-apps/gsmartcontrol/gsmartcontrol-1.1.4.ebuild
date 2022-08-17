# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic xdg

DESCRIPTION="Hard disk drive health inspection tool"
HOMEPAGE="https://gsmartcontrol.sourceforge.io/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="|| ( GPL-2 GPL-3 ) Boost-1.0 BSD Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-cpp/gtkmm:3.0
	dev-libs/libpcre:3
	sys-apps/smartmontools"
RDEPEND="${DEPEND}
	x11-apps/xmessage"
BDEPEND="virtual/pkgconfig
	test? ( dev-util/gtk-builder-convert )"

DOCS=( TODO ) # See 'dist_doc_DATA' value in Makefile.am

src_configure() {
	append-cxxflags -std=c++11

	econf $(use test tests)
}

src_install() {
	default

	rm "${ED}"/usr/share/doc/${PF}/LICENSE_* || die
}
