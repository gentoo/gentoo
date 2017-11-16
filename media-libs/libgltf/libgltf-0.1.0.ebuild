# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="git://gerrit.libreoffice.org/libgltf.git"
[[ ${PV} == 9999 ]] && inherit autotools git-r3

DESCRIPTION="C++ Library for rendering OpenGL models stored in glTF format"
HOMEPAGE="http://www.libreoffice.org https://gerrit.libreoffice.org/gitweb?p=libgltf.git"
[[ ${PV} == 9999 ]] || SRC_URI="http://dev-www.libreoffice.org/src/${PN}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="amd64 x86"
IUSE="debug test"

RDEPEND="
	>=media-libs/libepoxy-1.3.1
	virtual/opengl
"
DEPEND="${RDEPEND}
	dev-libs/boost
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
		--disable-werror \
		$(use_enable debug) \
		$(use_enable test tests)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
