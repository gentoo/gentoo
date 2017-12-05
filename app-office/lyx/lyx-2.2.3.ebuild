# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit gnome2-utils eutils fdo-mime flag-o-matic font python-single-r1 toolchain-funcs

MY_P="${P/_}"

S="${WORKDIR}/${MY_P}"
FONT_S="${S}/lib/fonts"
FONT_SUFFIX="ttf"
DESCRIPTION="WYSIWYM frontend for LaTeX, DocBook, etc."
HOMEPAGE="http://www.lyx.org/"
SRC_URI="ftp://ftp.lyx.org/pub/lyx/stable/2.2.x/${MY_P}.tar.xz
	ftp://ftp.lyx.org/pub/lyx/devel/lyx-2.2/${MY_P}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x64-macos ~x86-macos"
IUSE="cups debug nls +latex monolithic-build html rtf dot docbook dia subversion rcs svg gnumeric +hunspell aspell enchant +qt4 qt5"

LANGS="ar ca cs da de el en es eu fi fr gl he hu ia id it ja nb nn pl pt_BR pt_PT ro ru sk sr sv tr uk zh_CN zh_TW"

for X in ${LANGS}; do
	IUSE="${IUSE} linguas_${X}"
done

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	qt4? ( !qt5 )
	qt5? ( !qt4 )"

DOCS=( ANNOUNCE NEWS README RELEASE-NOTES UPGRADING )

COMMONDEPEND=">=dev-libs/boost-1.34:=
	${PYTHON_DEPS}
	qt4? ( dev-qt/qtgui:4 dev-qt/qtcore:4 dev-qt/qtsvg:4 )
	qt5? ( dev-qt/qtgui:5 dev-qt/qtcore:5 dev-qt/qtwidgets:5 dev-qt/qtx11extras:5 dev-qt/qtsvg:5 dev-qt/qtconcurrent:5 )"

RDEPEND="${COMMONDEPEND}
	dev-texlive/texlive-fontsextra
	virtual/imagemagick-tools[png,svg?]
	cups? ( net-print/cups )
	latex? (
		app-text/texlive
		app-text/ghostscript-gpl
		app-text/noweb
		app-text/dvipng
		dev-tex/dvipost
		dev-tex/chktex
		app-text/ps2eps
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-pictures
		|| ( dev-texlive/texlive-mathscience dev-texlive/texlive-science )
		|| ( dev-texlive/texlive-plaingeneric dev-texlive/texlive-genericextra )
		dev-texlive/texlive-fontsrecommended
		|| (
			dev-tex/latex2html
			dev-tex/tth
			dev-tex/hevea
			dev-tex/tex4ht[java]
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
	subversion? ( dev-vcs/subversion )
	rcs? ( dev-vcs/rcs )
	svg? ( || ( gnome-base/librsvg media-gfx/inkscape ) )
	gnumeric? ( app-office/gnumeric )
	hunspell? ( app-text/hunspell )
	aspell? ( app-text/aspell )
	enchant? ( app-text/enchant )"

DEPEND="${COMMONDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

pkg_setup() {
	python-single-r1_pkg_setup
	font_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/2.1-python.patch
	sed "s:python -tt:${EPYTHON} -tt:g" -i lib/configure.py || die
	if use qt4; then
		export QT_SELECT=qt4
	elif use qt5; then
		export QT_SELECT=qt5
	fi
}

src_configure() {
	tc-export CXX
	#bug 221921
	export VARTEXFONTS=${T}/fonts
	local qt_flag=""
	if use qt4; then
		qt_flag=""
	elif use qt5; then
		qt_flag="--enable-qt5"
	fi

	econf \
		$(use_enable nls) \
		$(use_enable debug) \
		$(use_enable monolithic-build) \
		$(use_with hunspell) \
		$(use_with aspell) \
		$(use_with enchant) \
		${qt_flag} \
		--without-included-boost \
		--disable-stdlib-debug \
		--with-packaging=posix
}

src_install() {
	default

	if use linguas_he ; then
		echo "\bind_file cua" > "${T}"/hebrew.bind
		echo "\bind \"F12\" \"language hebrew\"" >> "${T}"/hebrew.bind

		insinto /usr/share/lyx/bind
		doins "${T}"/hebrew.bind || die
	fi

	newicon -s 32 "${S}/development/Win32/packaging/icons/lyx_32x32.png" ${PN}.png
	doicon -s 48 "${S}/lib/images/lyx.png"
	doicon -s scalable "${S}/lib/images/lyx.svg"

	# fix for bug 91108
	if use latex ; then
		dosym ../../../lyx/tex /usr/share/texmf-site/tex/latex/lyx || die
	fi

	# fonts needed for proper math display, see also bug #15629
	font_src_install

	python_fix_shebang "${ED}"/usr/share/${PN}

	if use hunspell ; then
		dosym ../myspell /usr/share/lyx/dicts
		dosym ../myspell /usr/share/lyx/thes
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	font_pkg_postinst
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update

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
	fdo-mime_desktop_database_update

	if use latex ; then
		texhash
	fi
}
