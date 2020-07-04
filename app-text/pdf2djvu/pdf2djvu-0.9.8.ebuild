# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 toolchain-funcs flag-o-matic

DESCRIPTION="A tool to create DjVu files from PDF files"
HOMEPAGE="http://jwilk.net/software/pdf2djvu"
SRC_URI="https://github.com/jwilk/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+graphicsmagick nls openmp test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-text/djvu-3.5.21:=
	>=app-text/poppler-0.16.7:=
	dev-libs/libxml2:=
	dev-libs/libxslt:=
	graphicsmagick? ( media-gfx/graphicsmagick:= )
"
DEPEND="${RDEPEND}
	dev-cpp/pstreams
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/nose[${PYTHON_USEDEP}]')
	)
"

REQUIRED_USE="test? ( graphicsmagick )"

DOCS=(
	doc/{changelog,credits,djvudigital,README}
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	# bug 626874, poppler headers require C++11
	append-cxxflags -std=c++11
	default
}

src_configure() {
	local openmp=--disable-openmp
	use openmp && tc-has-openmp && openmp=--enable-openmp

	econf \
		${openmp} \
		$(use_enable nls) \
		$(use_with graphicsmagick)
}
