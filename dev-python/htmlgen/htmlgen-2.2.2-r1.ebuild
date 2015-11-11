# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1

MY_P="HTMLgen"
DESCRIPTION="HTMLgen - Python modules for the generation of HTML documents"
HOMEPAGE="http://starship.python.net/crew/friedrich/HTMLgen/html/main.html"
SRC_URI="http://starship.python.net/crew/friedrich/${MY_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ia64 ppc x86"
IUSE="doc"

DEPEND="${PYTHON_DEPS}
	dev-python/pillow[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${P}-python-2.5.patch"
	epatch "${FILESDIR}/${PN}-pillow.patch"
}

src_compile() {
	return 0
}

src_install() {
	# doing this manually because their build scripts suck
	local files="HTMLgen.py HTMLcolors.py HTMLutil.py HTMLcalendar.py
	barchart.py colorcube.py imgsize.py NavLinks.py Formtools.py
	ImageH.py ImageFileH.py ImagePaletteH.py GifImagePluginH.py
	JpegImagePluginH.py PngImagePluginH.py"

	mkdir htmlgen || die
	touch htmlgen/__init__.py || die
	ln ${files} htmlgen/ || die
	python_foreach_impl python_domodule htmlgen

	if use doc; then
		# fix the image locations in the docs
		sed -i -e "s;../image/;image/;g" html/* || die "sed failed"
		dohtml html/*
		dohtml -r image
	fi
	dodoc README
}

pkg_postinst() {
	ewarn "htmlgen now resides in its own subdirectory"
	ewarn "so you need to do \"from htmlgen import HTMLgen\" instead of \"import HTMLgen\""
}
