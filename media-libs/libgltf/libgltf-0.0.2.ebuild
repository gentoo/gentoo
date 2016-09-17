# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="git://gerrit.libreoffice.org/libgltf.git"
inherit eutils
[[ ${PV} == 9999 ]] && inherit autotools git-r3

DESCRIPTION="C++ Library for rendering OpenGL models stored in glTF format"
HOMEPAGE="http://www.libreoffice.org"
[[ ${PV} == 9999 ]] || SRC_URI="http://dev-www.libreoffice.org/src/${PN}/${P}.tar.bz2"

LICENSE="MPL-2.0"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="amd64 x86"
IUSE="debug test"

RDEPEND="virtual/opengl"

DEPEND="${RDEPEND}
	dev-libs/boost
	media-libs/glew:=
	media-libs/glm
	sys-devel/libtool
	virtual/pkgconfig
"

# testsuite not in tarball
# only in git; unsure
RESTRICT="test"

src_prepare() {
	default
	[[ -d m4 ]] || mkdir "m4"
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--disable-werror \
		$(use_enable test tests)
}

src_install() {
	default
	prune_libtool_files --all
}
