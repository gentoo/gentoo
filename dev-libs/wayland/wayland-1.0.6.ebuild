# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/wayland/wayland-1.0.6.ebuild,v 1.2 2013/05/16 00:40:59 mattst88 Exp $

EAPI=5

EGIT_REPO_URI="git://anongit.freedesktop.org/git/${PN}/${PN}"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-2"
	EXPERIMENTAL="true"
fi

inherit autotools toolchain-funcs $GIT_ECLASS

DESCRIPTION="Wayland protocol libraries"
HOMEPAGE="http://wayland.freedesktop.org/"

if [[ $PV = 9999* ]]; then
	SRC_URI="${SRC_PATCHES}"
else
	SRC_URI="http://wayland.freedesktop.org/releases/${P}.tar.xz"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="doc static-libs"

RDEPEND="dev-libs/expat
	virtual/libffi"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	if [[ ${PV} = 9999* ]]; then
		eautoreconf
	fi
}

src_configure() {
	myconf="$(use_enable static-libs static) \
			$(use_enable doc documentation)"
	if tc-is-cross-compiler ; then
		myconf+=" --disable-scanner"
	fi
	econf ${myconf}
}
