# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 vala

DESCRIPTION="A collection of different plugins for Geany"
HOMEPAGE="https://plugins.geany.org"
SRC_URI="https://plugins.geany.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="gtk3 ctags debugger enchant git gpg gtkspell lua multiterm nls pretty-printer python scope soup"
REQUIRED_USE="
	gtk3? ( !debugger !multiterm !python !scope )
	python? ( ${PYTHON_REQUIRED_USE} )
"

COMMON_DEPEND="
	>=dev-util/geany-1.32[gtk3=]
	dev-libs/glib:2
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
	ctags? ( dev-util/ctags )
	debugger? ( x11-libs/vte:0 )
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
		>=x11-libs/vte-0.28:0
		)
	pretty-printer? ( dev-libs/libxml2:2 )
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
	default

	use multiterm && vala_src_prepare
}

src_configure() {
	local myeconfargs=(
		--disable-cppcheck
		--disable-extra-c-warnings
		$(use_enable nls)
		--enable-utilslib
		# Plugins
		--enable-addons
		--enable-autoclose
		--enable-automark
		--enable-codenav
		--enable-commander
		--enable-defineformat
		--enable-geanyextrasel
		--enable-geanyinsertnum
		--enable-geanylatex
		--enable-geanymacro
		--enable-geanyminiscript
		--enable-geanynumberedbookmarks
		--enable-geanyprj
		--enable-geanyvc $(use_enable gtkspell)
		--enable-lineoperations
		--enable-lipsum
		--enable-keyrecord
		--enable-overview
		--enable-pairtaghighlighter
		--enable-pohelper
		--enable-projectorganizer
		--enable-sendmail
		--enable-shiftcolumn
		--enable-tableconvert
		--enable-treebrowser
		--enable-workbench
		--enable-xmlsnippets
		$(use_enable debugger)
		$(use_enable ctags geanyctags)
		$(use_enable !gtk3 geanydoc)
		$(use_enable lua geanylua)
		$(use_enable gpg geanypg)
		$(use_enable python geanypy)
		$(use_enable soup geniuspaste)
		$(use_enable git gitchangebar)
		$(use_enable multiterm)
		$(use_enable pretty-printer)
		$(use_enable scope)
		$(use_enable enchant spellcheck)
		# Having updatechecker… when you’re using a package manager?
		$(use_enable soup updatechecker)
		# GeanyGenDoc requires ctpl which isn’t yet in portage
		--disable-geanygendoc
		# Require obsolete and vulnerable webkit-gtk versions
		--disable-devhelp
		--disable-markdown --disable-peg-markdown
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
