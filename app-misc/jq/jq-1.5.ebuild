# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="A lightweight and flexible command-line JSON processor"
HOMEPAGE="https://stedolan.github.com/jq/"
SRC_URI="https://github.com/stedolan/jq/releases/download/${P}/${P}.tar.gz"

LICENSE="MIT CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE="oniguruma static-libs test"

DEPEND="sys-devel/bison
	sys-devel/flex
	oniguruma? ( dev-libs/oniguruma[static-libs?] )
	test? ( dev-util/valgrind )"

DOCS=( AUTHORS README )

PATCHES=(
	"${FILESDIR}"/${PN}-1.5-dynamic-link.patch
	"${FILESDIR}"/${P}-remove-automagic-dep-on-oniguruma.patch
)

src_prepare() {
	sed -i '/^dist_doc_DATA/d' Makefile.am || die
	sed -i -r "s:(m4_define\(\[jq_version\],) .+\):\1 \[${PV}\]):" \
		configure.ac || die

	default
	eautoreconf
}

src_configure() {
	# don't try to rebuild docs
	econf \
		--disable-docs \
		$(use_enable static-libs static) \
		$(use_with oniguruma)
}

src_install() {
	default
	use static-libs || find "${ED}" -name libjq.la -delete
}
