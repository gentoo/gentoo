# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://github.com/blogc/blogc.git
		https://github.com/blogc/blogc.git"
	inherit git-r3 autotools
fi

DESCRIPTION="A blog compiler"
HOMEPAGE="http://blogc.org/"

MY_PV="${PV/_/-}"
MY_PV="${MY_PV/beta/beta.}"

MY_P="${PN}-${MY_PV}"

SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.xz"
KEYWORDS="~amd64 ~x86"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
	DEPEND="app-text/ronn"
else
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND=""

# pkg-config is used only to find cmocka libraries
DEPEND="${DEPEND}
	test? (
		virtual/pkgconfig
		dev-util/cmocka )"

src_prepare() {
	[[ ${PV} = *9999* ]] && eautoreconf
	default
}

src_configure() {
	local myconf=""
	if [[ ${PV} = *9999* ]]; then
		myconf+="--enable-ronn"
	else
		myconf+="--disable-ronn"
	fi
	econf \
		$(use_enable test tests) \
		--disable-valgrind \
		${myconf}
}
