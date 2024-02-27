# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A library and tools for trace processing"
HOMEPAGE="https://research.wand.net.nz/software/libtrace.php"
SRC_URI="https://github.com/${PN^}Team/${PN}/archive//${PV/_p/-}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P/_p/-}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# doxygen is always needed for man pages, but USE=doc controls installing docs themselves
# (not man pages)
IUSE="doc ncurses numa"

RDEPEND=">=net-libs/libpcap-0.8
	dev-libs/libyaml
	dev-libs/openssl:=
	net-libs/wandio
	ncurses? ( sys-libs/ncurses:= )
	numa? ( sys-process/numactl )"
DEPEND="${RDEPEND}"
BDEPEND="app-text/doxygen[dot]
	app-alternatives/lex
	virtual/os-headers
	virtual/pkgconfig
	app-alternatives/yacc"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.18_p1-build-system.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die

	eautoreconf

	# Comment out FILE_PATTERNS definition (bug #706230)
	if has_version ~app-text/doxygen-1.8.16; then
		sed -i -e '/^FILE_PATTERNS/s|^|#|g' docs/${PN}.doxygen.in || die
	fi

	# Update doxygen configuration
	doxygen -u docs/libtrace.doxygen.in || die
}

src_configure() {
	econf \
		$(use_with ncurses) \
		$(use_with numa) \
		--with-man \
		--without-dpdk
}

src_install() {
	default

	if use doc ; then
		docinto html
		dodoc -r docs/doxygen/html
	fi

	find "${ED}" -name "*.la" -delete || die
}
