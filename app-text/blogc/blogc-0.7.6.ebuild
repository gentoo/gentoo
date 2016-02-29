# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="
		git://github.com/blogc/blogc.git
		https://github.com/blogc/blogc.git"
	inherit git-r3 autotools
fi

DESCRIPTION="A blog compiler"
HOMEPAGE="http://blogc.org/"

SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
	RDEPEND="=dev-libs/squareball-9999"
	DEPEND="${RDEPEND}
		app-text/ronn"
else
	RDEPEND=">=dev-libs/squareball-0.1"
	DEPEND="${RDEPEND}"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"

DEPEND="${DEPEND}
	virtual/pkgconfig
	test? (
		dev-util/cmocka )"

src_prepare() {
	[[ ${PV} = *9999* ]] && eautoreconf
	eapply_user
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
		--with-squareball=system \
		${myconf}
}
