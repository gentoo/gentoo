# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="
		git://github.com/rafaelmartins/squareball.git
		https://github.com/rafaelmartins/squareball.git"
	inherit git-r3 autotools
fi

inherit eutils

DESCRIPTION="A general-purpose library for C99"
HOMEPAGE="https://github.com/rafaelmartins/squareball"

SRC_URI="https://github.com/rafaelmartins/${PN}/releases/download/v${PV}/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
fi

LICENSE="BSD"
SLOT="0"
IUSE="doc test static-libs"

RDEPEND=""

DEPEND="
	virtual/pkgconfig
	test? (
		dev-util/cmocka )
	doc? (
		app-doc/doxygen )"

src_prepare() {
	[[ ${PV} = *9999* ]] && eautoreconf
	default
}

src_configure() {
	econf \
		$(use_enable doc) \
		$(use_enable test tests) \
		$(use_enable static-libs static) \
		--disable-valgrind
}

src_compile() {
	default
	use doc && emake docs
}

src_install() {
	use doc && HTML_DOCS=( doc/build/html/* )
	default
	prune_libtool_files --all
}
