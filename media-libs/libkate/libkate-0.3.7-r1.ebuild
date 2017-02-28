# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-single-r1

DESCRIPTION="Codec for karaoke and text encapsulation for Ogg"
HOMEPAGE="https://code.google.com/p/libkate/"
SRC_URI="https://libkate.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="doc wxwidgets"

COMMON_DEPEND="media-libs/libogg:=
	media-libs/libpng:0="
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	sys-devel/flex
	sys-devel/bison
	doc? ( app-doc/doxygen )"
RDEPEND="${COMMON_DEPEND}
	wxwidgets? (
		${PYTHON_DEPS}
		=dev-python/wxpython-2.8*[${PYTHON_USEDEP}]
		media-libs/liboggz )"

REQUIRED_USE="wxwidgets? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}"/${P}-libpng14.patch
)

pkg_setup() {
	use wxwidgets && python-single-r1_pkg_setup
}

src_configure() {
	if ! use wxwidgets; then
		sed -i -e "s/HAVE_PYTHON=yes/HAVE_PYTHON=no/" configure || die
	fi

	econf $(use_enable doc)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README
	use wxwidgets && python_fix_shebang "${D}"
}
