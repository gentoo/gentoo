# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils

DESCRIPTION="A set of tools to collect and process netflow data"
HOMEPAGE="https://github.com/phaag/nfdump"
SRC_URI="
	${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD"
SLOT="0/1.6.15"
KEYWORDS="~amd64 ~x86"
IUSE="compat15 debug ftconv nfprofile nftrack readpcap sflow static-libs"

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
	sys-devel/flex
	virtual/yacc
"
RDEPEND="
	${COMMON_DEPEND}
	dev-lang/perl
"
DOCS=( AUTHORS ChangeLog README.md )
PATCHES=(
	"${FILESDIR}"/${PN}-1.6.14-libft.patch
	"${FILESDIR}"/${PN}-1.6.16-libnfdump.patch
	"${FILESDIR}"/${PN}-1.6.16-DEVEL.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# --without-ftconf is not handled well #322201
	econf \
		$(use ftconv && echo "--enable-ftconv --with-ftpath=/usr") \
		$(use nfprofile && echo --enable-nfprofile) \
		$(use nftrack && echo --enable-nftrack) \
		$(use_enable compat15) \
		$(use_enable debug devel) \
		$(use_enable readpcap) \
		$(use_enable sflow) \
		$(use_enable static-libs static)
}

src_install() {
	default

	prune_libtool_files
}
