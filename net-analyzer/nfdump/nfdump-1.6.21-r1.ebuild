# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="A set of tools to collect and process netflow data"
HOMEPAGE="https://github.com/phaag/nfdump"
SRC_URI="https://github.com/phaag/nfdump/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/1.6.15"
KEYWORDS="amd64 x86"
IUSE="debug doc ftconv nfprofile nftrack readpcap sflow static-libs"

COMMON_DEPEND="
	app-arch/bzip2
	sys-libs/zlib
	ftconv? ( sys-libs/zlib net-analyzer/flow-tools )
	nfprofile? ( net-analyzer/rrdtool )
	nftrack? ( net-analyzer/rrdtool )
	readpcap? ( net-libs/libpcap )
"
DEPEND="
	${COMMON_DEPEND}
"
BDEPEND="
	sys-devel/flex
	virtual/yacc
	doc? ( app-doc/doxygen )
"
RDEPEND="
	${COMMON_DEPEND}
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.6.19-compiler.patch
	"${FILESDIR}"/${PN}-1.6.19-libft.patch
	"${FILESDIR}"/${PN}-1.6.21-remove-strict-rfc-7011-handling.patch
)

DOCS=( AUTHORS ChangeLog README.md )

src_prepare() {
	default

	eautoreconf

	if use doc; then
		doxygen -u doc/Doxyfile.in || die
	fi
}

src_configure() {
	# --without-ftconf is not handled well #322201
	econf \
		$(use ftconv && echo "--enable-ftconv --with-ftpath=/usr") \
		$(use nfprofile && echo --enable-nfprofile) \
		$(use nftrack && echo --enable-nftrack) \
		$(use_enable debug devel) \
		$(use_enable readpcap) \
		$(use_enable sflow) \
		$(use_enable static-libs static)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	if use doc; then
		dodoc -r doc/html
	fi
}
