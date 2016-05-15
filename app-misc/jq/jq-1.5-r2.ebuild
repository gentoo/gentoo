# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils

DESCRIPTION="A lightweight and flexible command-line JSON processor"
HOMEPAGE="https://stedolan.github.com/jq/"
SRC_URI="https://github.com/stedolan/jq/releases/download/${P}/${P}.tar.gz"

LICENSE="MIT CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~x64-macos"
IUSE="oniguruma static-libs test"

DEPEND="
	>=sys-devel/bison-3.0
	sys-devel/flex
	oniguruma? ( dev-libs/oniguruma[static-libs?] )
	test? ( dev-util/valgrind )
"
RDEPEND="
	!static-libs? (
		oniguruma? ( dev-libs/oniguruma[static-libs?] )
	)
"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-1.5-dynamic-link.patch
		"${FILESDIR}"/${PN}-1.5-remove-automagic-dep-on-oniguruma.patch
		"${FILESDIR}"/${PN}-1.5-heap_buffer_overflow_in_tokenadd.patch
	)

	sed -i '/^dist_doc_DATA/d' Makefile.am || die
	sed -i -r "s:(m4_define\(\[jq_version\],) .+\):\1 \[${PV}\]):" \
		configure.ac || die

	default
	eautoreconf
}

src_configure() {
	local econfargs=(
		# don't try to rebuild docs
		--disable-docs
		$(use_enable static-libs static)
		$(use_with oniguruma)
	)
	econf "${econfargs[@]}"
}

src_install() {
	local DOCS=( AUTHORS README )
	default

	use static-libs || prune_libtool_files
}
