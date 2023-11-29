# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

MY_P="${P/_}"
inherit desktop font optfeature python-single-r1 qmake-utils toolchain-funcs xdg-utils

DESCRIPTION="WYSIWYM (What You See Is What You Mean) document processor based on LaTeX"
HOMEPAGE="https://www.lyx.org/"
SRC_URI="http://ftp.lyx.org/pub/lyx/stable/$(ver_cut 1-2).x/${MY_P}-1.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"
IUSE="aspell cups debug dia dot enchant gnumeric html +hunspell +latex monolithic-build nls rcs rtf svg l10n_he"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# bc needed http://comments.gmane.org/gmane.editors.lyx.devel/137498 and bug #787839
BDEPEND="
	sys-devel/bc
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
RDEPEND="${PYTHON_DEPS}
	app-text/mythes
	dev-libs/boost:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	sys-apps/file
	sys-libs/zlib
	virtual/imagemagick-tools[png,svg?]

	x11-misc/xdg-utils

	aspell? ( app-text/aspell )
	cups? ( net-print/cups )
	dia? ( app-office/dia )
	dot? ( media-gfx/graphviz )
	enchant? ( app-text/enchant:2 )
	gnumeric? ( app-office/gnumeric )
	html? ( dev-tex/html2latex )
	hunspell? ( app-text/hunspell )
	l10n_he? ( dev-tex/culmus-latex )
	latex? (
		app-text/dvipng
		app-text/ghostscript-gpl
		app-text/ps2eps
		app-text/texlive
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-mathscience
		dev-texlive/texlive-pictures
		dev-texlive/texlive-plaingeneric
		|| (
			dev-tex/hevea
			dev-tex/latex2html
			dev-tex/tex4ht[java]
			dev-tex/tth
		)
	)
	rcs? ( dev-vcs/rcs )
	rtf? (
		app-text/unrtf
		dev-tex/html2latex
		dev-tex/latex2rtf
	)
	svg? ( || ( gnome-base/librsvg media-gfx/inkscape ) )
"
DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5
"

DOCS=( ANNOUNCE NEWS README RELEASE-NOTES UPGRADING )

S="${WORKDIR}/${MY_P}"

FONT_S="${S}/lib/fonts"
FONT_SUFFIX="ttf"

PATCHES=(
	# Try first with xdg-open before hardcoded commands
	# Patch from Debian using a similar approach to Fedora
	"${FILESDIR}"/${PN}-prefer-xdg-open.patch

	# Already part of 2.4.x (from Fedora)
	# https://bugzilla.redhat.com/show_bug.cgi?id=1965118
	"${FILESDIR}"/${PN}-2.3.6.1-python.patch
)

pkg_setup() {
	python-single-r1_pkg_setup
	font_pkg_setup
}

src_prepare() {
	default

	sed "s:python -tt:${EPYTHON} -tt:g" -i lib/configure.py || die
}

src_configure() {
	tc-export CXX
	#bug 221921
	export VARTEXFONTS="${T}"/fonts

	econf \
		$(use_with aspell) \
		$(use_enable debug) \
		$(use_with enchant) \
		$(use_with hunspell) \
		$(use_enable monolithic-build) \
		$(use_enable nls) \
		--enable-qt5 \
		--with-qt-dir=$(qt5_get_libdir)/qt5 \
		--disable-stdlib-debug \
		--without-included-boost \
		--with-packaging=posix
}

src_install() {
	default

	if use l10n_he ; then
		echo "\bind_file cua" > "${T}"/hebrew.bind || die
		echo "\bind \"F12\" \"language hebrew\"" >> "${T}"/hebrew.bind || die

		insinto /usr/share/lyx/bind
		doins "${T}"/hebrew.bind
	fi

	newicon -s 32 "development/Win32/packaging/icons/lyx_32x32.png" ${PN}.png
	doicon -s 48 "lib/images/lyx.png"
	doicon -s scalable "lib/images/lyx.svg"

	# fix for bug 91108
	if use latex ; then
		dosym ../../../lyx/tex /usr/share/texmf-site/tex/latex/lyx
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
	# Workaround https://bugs.gentoo.org/907288
	if has_version "<${CATEGORY}/${PN}-2.3.7"; then
		ewarn "dev-texlive/texlive-fontsextra is now an optional dependency"
		ewarn "If you need these fonts, you will need to manually install"
		ewarn "them."
	fi
}

pkg_postinst() {
	font_pkg_postinst
	xdg_icon_cache_update
	xdg_desktop_database_update

	# fix for bug 91108
	if use latex ; then
		texhash || die
	fi

	# instructions for RTL support. See also bug 168331.
	if use l10n_he || has he ${LINGUAS} || has ar ${LINGUAS} ; then
		elog
		elog "Enabling RTL support in LyX:"
		elog "If you intend to use a RTL language (such as Hebrew or Arabic)"
		elog "You must enable RTL support in LyX. To do so start LyX and go to"
		elog "Tools->Preferences->Language settings->Language"
		elog "and make sure the \"Right-to-left language support\" is checked"
		elog
	fi

	optfeature "handling more fonts" dev-texlive/texlive-fontsextra
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update

	if use latex ; then
		texhash || die
	fi
}
