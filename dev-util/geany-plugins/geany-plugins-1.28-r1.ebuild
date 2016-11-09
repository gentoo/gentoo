# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 vala

DESCRIPTION="A collection of different plugins for Geany"
HOMEPAGE="https://plugins.geany.org"
SRC_URI="https://plugins.geany.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="gtk3 +autoclose +automark +commander ctags debugger +defineformat enchant git gpg gtkspell lua multiterm nls +overview python scope soup"
REQUIRED_USE="
	gtk3? ( !debugger !multiterm !python !scope )
	python? ( ${PYTHON_REQUIRED_USE} )
"

GTK_COMMON_DEPEND="
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
"
COMMON_DEPEND="
	>=dev-util/geany-1.26[gtk3=]
	dev-libs/glib:2
	dev-libs/libxml2:2
	autoclose? ( ${GTK_COMMON_DEPEND} )
	commander? ( ${GTK_COMMON_DEPEND} )
	ctags? ( dev-util/ctags )
	debugger? ( x11-libs/vte:0 )
	defineformat? ( ${GTK_COMMON_DEPEND} )
	enchant? ( app-text/enchant )
	git? ( dev-libs/libgit2:= )
	gpg? ( app-crypt/gpgme:1= )
	gtkspell? (
		gtk3? ( app-text/gtkspell:3= )
		!gtk3? ( app-text/gtkspell:2 )
		)
	lua? ( dev-lang/lua:0= )
	multiterm? (
		$(vala_depend)
		x11-libs/gtk+:2
		>=x11-libs/vte-0.28:0
		)
	python? (
		dev-python/pygtk[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
		)
	scope? ( x11-libs/vte:0 )
	soup? ( net-libs/libsoup:2.4 )
"
RDEPEND="${COMMON_DEPEND}
	scope? ( sys-devel/gdb )
"
DEPEND="${COMMON_DEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# bundled lib buster
	rm markdown/peg-markdown/markdown_lib.c || die
	# devhelp plugin bundles devhelp

	default

	use multiterm && vala_src_prepare

	# make fails if LINGUAS contains a language which is not translated
	local po_linguas=""
	for lang in $LINGUAS; do
		if [[ -e "$S/po/$lang.po" ]]; then
			po_linguas="${po_linguas} $lang"
		fi
	done
	# only filter LINGUAS if defined
	if [[ -n "${LINGUAS+x}" ]]; then
		LINGUAS=$po_linguas
	fi
}

src_configure() {
	local myeconfargs=(
		--disable-cppcheck
		--disable-extra-c-warnings
		$(use_enable !gtk3 geanydoc)
		# GeanyGenDoc requires ctpl which isn’t yet in portage
		--disable-geanygendoc
		# peg-markdown is bundled, use app-text/discount instead
		--disable-peg-markdown
		--enable-addons
		--enable-codenav
		--enable-geanyextrasel
		--enable-geanyinsertnum
		--enable-geanylatex
		--enable-geanylipsum
		--enable-geanymacro
		--enable-geanynumberedbookmarks
		--enable-geanyprj
		--enable-geanyvc
		--enable-lineoperations
		--enable-pairtaghighlighter
		--enable-pohelper
		--enable-pretty-printer
		--enable-projectorganizer
		--enable-sendmail
		--enable-shiftcolumn
		--enable-tableconvert
		--enable-treebrowser
		--enable-xmlsnippets
		$(use_enable autoclose)
		$(use_enable automark)
		$(use_enable commander)
		$(use_enable ctags geanyctags)
		$(use_enable debugger)
		$(use_enable defineformat)
		$(use_enable enchant spellcheck)
		$(use_enable git gitchangebar)
		$(use_enable gpg geanypg)
		$(use_enable gtkspell)
		$(use_enable multiterm)
		$(use_enable lua geanylua)
		$(use_enable nls)
		$(use_enable overview)
		$(use_enable python geanypy)
		$(use_enable scope)
		# Having updatechecker… when you’re using a package manager?
		$(use_enable soup updatechecker)
		$(use_enable soup geniuspaste)
		# Relies on obsolete and vulnerable webkit-gtk versions
		--disable-devhelp
		--disable-markdown
		--disable-webhelper
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	prune_libtool_files --modules

	# make installs all translations if LINGUAS is empty
	if [[ -n "${LINGUAS+x}" && -z "$LINGUAS" ]]; then
		rm -r "${D}/usr/share/locale/" || die
	fi
}
