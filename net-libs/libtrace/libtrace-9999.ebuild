# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="A library and tools for trace processing"
HOMEPAGE="https://research.wand.net.nz/software/libtrace.php"
S="${WORKDIR}/${P/_beta/}"
EGIT_REPO_URI="https://github.com/LibtraceTeam/libtrace"
EGIT_SUBMODULES=()

LICENSE="LGPL-3"
SLOT="0"
IUSE="doc ncurses numa"

BDEPEND="
	app-doc/doxygen[dot]
	sys-devel/flex
	virtual/os-headers
	virtual/pkgconfig
	virtual/yacc
"
RDEPEND="
	>=net-libs/libpcap-0.8
	dev-libs/libyaml
	dev-libs/openssl:0=
	net-libs/wandio
	ncurses? ( sys-libs/ncurses:0= )
	numa? ( sys-process/numactl )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.20-autoconf-1.13.patch
	"${FILESDIR}"/${PN}-4.0.0-no-examples.patch
	"${FILESDIR}"/${PN}-4.0.0-with-numa.patch
	"${FILESDIR}"/${PN}-4.0.9_p1-tinfo.patch
)

src_prepare() {
	default

	eautoreconf

	# Comment out FILE_PATTERNS definition (bug #706230)
	if has_version ~app-doc/doxygen-1.8.16; then
		sed -i -e '/^FILE_PATTERNS/s|^|#|g' docs/${PN}.doxygen.in || die
	fi

	# Update doxygen configuration
	doxygen -u docs/libtrace.doxygen.in || die
}

src_configure() {
	econf \
		$(use_with ncurses) \
		$(use_with numa) \
		--disable-static \
		--with-man
}

src_install() {
	default

	if use doc ; then
		docinto html
		dodoc -r docs/doxygen/html
	fi

	find "${ED}" -name "*.la" -delete || die
}
