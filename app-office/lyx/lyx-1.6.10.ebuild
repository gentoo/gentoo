# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/lyx/lyx-1.6.10.ebuild,v 1.14 2013/03/02 19:36:00 hwoarang Exp $

EAPI=2

PYTHON_DEPEND="2"

inherit gnome2-utils qt4-r2 eutils flag-o-matic font python toolchain-funcs

MY_P="${P/_}"

S="${WORKDIR}/${MY_P}"
FONT_S="${S}/lib/fonts"
FONT_SUFFIX="ttf"
DESCRIPTION="WYSIWYM frontend for LaTeX, DocBook, etc."
HOMEPAGE="http://www.lyx.org/"
SRC_URI="ftp://ftp.lyx.org/pub/lyx/stable/1.6.x/${P}.tar.bz2"
#SRC_URI="ftp://ftp.devel.lyx.org/pub/lyx/stable/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~ia64 ~ppc ~ppc64 sparc x86"
IUSE="cups debug nls latex monolithic-build html rtf dot docbook dia subversion rcs svg"

LANGS="ar ca cs de el en es eu fi fr gl he hu id it ja nb nn pl pt ro ru sk tr uk zh_CN zh_TW"
for X in ${LANGS}; do
	IUSE="${IUSE} linguas_${X}"
done

COMMONDEPEND="dev-qt/qtgui:4
	dev-qt/qtcore:4
	x11-libs/libXrandr
	x11-libs/libXcursor
	x11-libs/libXrender
	x11-libs/libXfixes
	x11-libs/libXext
	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	dev-libs/libxml2
	app-text/aiksaurus
	app-text/aspell
	media-libs/fontconfig
	media-libs/freetype
	>=dev-libs/boost-1.34"

RDEPEND="${COMMONDEPEND}
	dev-texlive/texlive-fontsextra
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick )
	cups? ( net-print/cups )
	latex? (
		virtual/latex-base
		app-text/ghostscript-gpl
		app-text/noweb
		dev-tex/dvipost
		dev-tex/chktex
		app-text/ps2eps
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-pictures
		dev-texlive/texlive-science
		|| (
			dev-tex/latex2html
			dev-tex/tth
			dev-tex/hevea
			dev-tex/tex4ht
		)
	)
	html? ( dev-tex/html2latex )
	rtf? (
			dev-tex/latex2rtf
			app-text/unrtf
			dev-tex/html2latex
		)
	linguas_he? ( dev-tex/culmus-latex )
	docbook? ( app-text/sgmltools-lite )
	dot? ( media-gfx/graphviz )
	dia? ( app-office/dia )
	subversion? ( <dev-vcs/subversion-1.7.0 )
	rcs? ( dev-vcs/rcs )
	svg? ( || ( gnome-base/librsvg media-gfx/inkscape ) )"

DEPEND="${COMMONDEPEND}
	x11-proto/xproto
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

pkg_setup() {
	python_set_active_version 2
	font_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/1.6.7-python.patch
	epatch "${FILESDIR}"/1.6.10-gcc.patch
	echo "#!/bin/sh" > config/py-compile
	sed "s:python -tt:$(PYTHON) -tt:g" -i lib/configure.py || die
}

src_configure() {
	tc-export CXX
	#bug 221921
	export VARTEXFONTS=${T}/fonts

	econf \
		$(use_enable nls) \
		$(use_enable debug) \
		$(use_enable monolithic-build) \
		--with-aspell --without-included-boost --disable-stdlib-debug
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc ANNOUNCE NEWS README RELEASE-NOTES UPGRADING "${FONT_S}"/*.txt || die

	if use linguas_he ; then
		echo "\bind_file cua" > "${T}"/hebrew.bind
		echo "\bind \"F12\" \"language hebrew\"" >> "${T}"/hebrew.bind

		insinto /usr/share/lyx/bind
		doins "${T}"/hebrew.bind || die
	fi

	newicon -s 32 "$S/development/Win32/packaging/icons/lyx_32x32.png" ${PN}.png
	make_desktop_entry ${PN} "LyX" "${PN}" "Office" "MimeType=application/x-lyx;"

	# fix for bug 91108
	if use latex ; then
		dosym ../../../lyx/tex /usr/share/texmf/tex/latex/lyx || die
	fi

	# fonts needed for proper math display, see also bug #15629
	font_src_install

	python_convert_shebangs -r 2 "${D}"/usr/share/${PN}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	font_pkg_postinst
	gnome2_icon_cache_update

	# fix for bug 91108
	if use latex ; then
		texhash
	fi

	# instructions for RTL support. See also bug 168331.
	if use linguas_he || use linguas_ar; then
		elog
		elog "Enabling RTL support in LyX:"
		elog "If you intend to use a RTL language (such as Hebrew or Arabic)"
		elog "You must enable RTL support in LyX. To do so start LyX and go to"
		elog "Tools->Preferences->Language settings->Language"
		elog "and make sure the \"Right-to-left language support\" is checked"
		elog
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update

	if use latex ; then
		texhash
	fi
}
