# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 )

inherit lua-single

DESCRIPTION="A collection of different plugins for Geany"
HOMEPAGE="https://plugins.geany.org"
SRC_URI="https://plugins.geany.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"

IUSE="ctags debugger enchant git gpg gtkspell lua markdown nls pretty-printer scope soup workbench"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

DEPEND="
	dev-libs/glib:2
	>=dev-util/geany-1.37[-gtk2(-)]
	x11-libs/gtk+:3
	ctags? ( dev-util/ctags )
	debugger? ( x11-libs/vte:2.91 )
	enchant? ( app-text/enchant:= )
	git? ( dev-libs/libgit2:= )
	gpg? ( app-crypt/gpgme:1= )
	gtkspell? ( app-text/gtkspell:3= )
	lua? ( ${LUA_DEPS} )
	markdown? (
		app-text/discount
		net-libs/webkit-gtk:4
		)
	pretty-printer? ( dev-libs/libxml2:2 )
	scope? ( x11-libs/vte:2.91 )
	soup? ( net-libs/libsoup:2.4 )
	workbench? ( dev-libs/libgit2:= )
"
RDEPEND="${DEPEND}
	scope? ( sys-devel/gdb )
"
BDEPEND="virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

pkg_setup() {
	use lua && lua-single_pkg_setup
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
		--enable-geanydoc
		--enable-geanyextrasel
		--enable-geanyinsertnum
		--enable-geanymacro
		--enable-geanyminiscript
		--enable-geanynumberedbookmarks
		--enable-geanyprj
		--enable-geanyvc $(use_enable gtkspell)
		--enable-keyrecord
		--enable-latex
		--enable-lineoperations
		--enable-lipsum
		--enable-overview
		--enable-pairtaghighlighter
		--enable-pohelper
		--enable-projectorganizer
		--enable-sendmail
		--enable-shiftcolumn
		--enable-tableconvert
		--enable-treebrowser
		--enable-vimode
		--enable-xmlsnippets
		$(use_enable debugger)
		$(use_enable ctags geanyctags)
		$(use_enable lua geanylua)
		$(use_enable gpg geanypg)
		$(use_enable soup geniuspaste)
		$(use_enable git gitchangebar)
		$(use_enable markdown) --disable-peg-markdown # using app-text/discount instead
		$(use_enable pretty-printer)
		$(use_enable scope)
		$(use_enable enchant spellcheck)
		# Having updatechecker… when you’re using a package manager?
		$(use_enable soup updatechecker)
		$(use_enable workbench)
		# GeanyGenDoc requires ctpl which isn’t yet in portage
		--disable-geanygendoc
		# Require obsolete and vulnerable webkit-gtk versions
		--disable-devhelp
		--disable-webhelper
		# GTK 2 only
		--disable-geanypy
		--disable-multiterm
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die

	# make installs all translations if LINGUAS is empty
	if [[ -z "${LINGUAS-x}" ]]; then
		rm -r "${ED}/usr/share/locale/" || die
	fi
}
