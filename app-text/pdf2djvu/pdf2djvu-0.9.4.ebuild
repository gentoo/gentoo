# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 toolchain-funcs

DESCRIPTION="A tool to create DjVu files from PDF files"
HOMEPAGE="http://jwilk.net/software/pdf2djvu"
SRC_URI="https://bitbucket.org/jwilk/${PN}/downloads/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+graphicsmagick nls openmp test"

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
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

REQUIRED_USE="test? ( graphicsmagick ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use test && python-single-r1_pkg_setup
}

src_configure() {
	local openmp=--disable-openmp
	use openmp && tc-has-openmp && openmp=--enable-openmp

	econf \
		${openmp} \
		$(use_enable nls) \
		$(use_with graphicsmagick)
}

src_install() {
	default
	dodoc doc/{changelog,{cjk,credits,djvudigital}.txt}
}
