# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit desktop font optfeature python-single-r1 cmake xdg

DESCRIPTION="WYSIWYM (What You See Is What You Mean) document processor based on LaTeX"
HOMEPAGE="https://www.lyx.org/"
SRC_URI="http://ftp.lyx.org/pub/lyx/devel/lyx-$(ver_cut 1-2)/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="aspell cups dia dot enchant gnumeric html +hunspell +latex monolithic-build nls rcs rtf svg l10n_he"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	app-text/mythes
	dev-libs/boost:=
	sys-apps/file
	sys-libs/zlib:=
	virtual/imagemagick-tools[png,svg?]
	x11-misc/xdg-utils

	dev-qt/qtbase:6[concurrent,dbus,gui,widgets]
	dev-qt/qt5compat:6
	dev-qt/qtsvg:6

	aspell? ( app-text/aspell )
	cups? ( net-print/cups )
	dia? ( app-office/dia )
	dot? ( media-gfx/graphviz )
	enchant? ( app-text/enchant:2 )
	gnumeric? ( app-office/gnumeric )
	html? ( dev-tex/html2latex )
	hunspell? ( app-text/hunspell )
	l10n_he? (
		dev-tex/culmus-latex
		dev-texlive/texlive-langarabic
	)
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
			dev-tex/latex2html
			dev-tex/hevea
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
	svg? ( || (
		gnome-base/librsvg
		media-gfx/inkscape
	) )
"
DEPEND="${RDEPEND}"
# bc needed http://comments.gmane.org/gmane.editors.lyx.devel/137498 and bug #787839
BDEPEND="
	app-alternatives/bc
	virtual/pkgconfig
	dev-qt/qttools[linguist]
	nls? ( sys-devel/gettext )
"

DOCS=( ANNOUNCE NEWS README RELEASE-NOTES UPGRADING )

FONT_S="${S}/lib/fonts"
FONT_SUFFIX="ttf"

PATCHES=(
	"${FILESDIR}"/lyx-2.4.0-fix-hunspell.patch
	# Try first with xdg-open before hardcoded commands
	# Patch from Debian using a similar approach to Fedora
	"${FILESDIR}"/lyx-2.4.0-prefer-xdg-open.patch
)

pkg_setup() {
	python-single-r1_pkg_setup
	font_pkg_setup
}

src_prepare() {
	sed "s:python -tt:${EPYTHON} -tt:g" -i lib/configure.py || die
	cmake_src_prepare
}

src_configure() {
	#bug 221921
	export VARTEXFONTS="${T}"/fonts

	local mycmakeargs=(
		-DLYX_INSTALL=ON
		-DLYX_USE_QT=QT6
		-DLYX_INSTALL_PREFIX="${EPREFIX}/usr"
		-DLYX_CXX_FLAGS_EXTRA="${CXXFLAGS}"

		-DLYX_NLS=$(usex nls)
		-DLYX_ASPELL=$(usex aspell)
		-DLYX_ENCHANT=$(usex enchant)
		-DLYX_HUNSPELL=$(usex hunspell)

		# external dependencies
		-DLYX_EXTERNAL_Z=ON
		-DLYX_EXTERNAL_ICONV=ON
		-DLYX_EXTERNAL_HUNSPELL=ON
		-DLYX_EXTERNAL_MYTHES=ON
		-DLYX_EXTERNAL_BOOST=ON
		-DLYX_PROGRAM_SUFFIX=OFF

		# debug control
		-DLYX_NO_OPTIMIZE=OFF
		-DLYX_RELEASE=ON
		-DLYX_DEBUG=OFF
		-DLYX_DEBUG_GLIBC=OFF
		-DLYX_STDLIB_DEBUG=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	newicon -s 32 "development/Win32/packaging/icons/lyx_32x32.png" ${PN}.png
	doicon -s 48 "lib/images/lyx.png"
	doicon -s scalable "lib/images/lyx.svg"

	# fix for bug 91108
	if use latex; then
		dosym -r /usr/share/lyx/tex /usr/share/texmf-site/tex/latex/lyx
	fi

	# fonts needed for proper math display, see also bug #15629
	font_src_install

	python_fix_shebang "${ED}"/usr/share/${PN}

	if use hunspell; then
		dosym ../myspell /usr/share/lyx/dicts
		dosym ../myspell /usr/share/lyx/thes
	fi
}

pkg_postinst() {
	font_pkg_postinst
	xdg_pkg_postinst

	# fix for bug 91108
	if use latex ; then
		texhash || die
	fi

	optfeature "handling more fonts" dev-texlive/texlive-fontsextra
}

pkg_postrm() {
	font_pkg_postrm
	xdg_pkg_postrm

	if use latex ; then
		texhash || die
	fi
}
