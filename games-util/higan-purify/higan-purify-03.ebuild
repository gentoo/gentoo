# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs qmake-utils

MY_P=purify_v${PV}-source

DESCRIPTION="Rom purifier for higan"
HOMEPAGE="http://byuu.org/higan/"
SRC_URI="https://higan.googlecode.com/files/${MY_P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="qt4"

RDEPEND="
	dev-games/higan-ananke
	x11-libs/libX11
	!qt4? ( x11-libs/gtk+:2 )
	qt4? ( >=dev-qt/qtgui-4.5:4 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}/purify

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if [[ $(gcc-major-version) == 4 && $(gcc-minor-version) -lt 7 || $(gcc-major-version) -lt 4 ]] ; then
			eerror "You need at least sys-devel/gcc-4.7.0"
			die "You need at least sys-devel/gcc-4.7.0"
		fi
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-QA.patch
	sed -i \
		-e "/handle/s#/usr/local/lib#/usr/$(get_libdir)#" \
		nall/dl.hpp || die

	# regenerate .moc if needed
	if use qt4; then
		cd phoenix/qt || die
		 "$(qt4_get_bindir)"/moc -i -I. -o platform.moc platform.moc.hpp || die
	fi
}

src_compile() {
	if use qt4; then
		mytoolkit="qt"
	else
		mytoolkit="gtk"
	fi

	emake \
		platform="x" \
		compiler="$(tc-getCXX)" \
		phoenix="${mytoolkit}"
}

src_install() {
	dobin purify
}
