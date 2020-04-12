# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A collection of different plugins for Geany"
HOMEPAGE="https://plugins.geany.org"
SRC_URI="https://plugins.geany.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"

IUSE="+gtk3 ctags debugger enchant git gpg gtkspell lua markdown nls pretty-printer scope soup workbench"
REQUIRED_USE="!gtk3? ( !markdown )"

DEPEND="
	dev-libs/glib:2
	>=dev-util/geany-1.35[gtk3=]
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
	ctags? ( dev-util/ctags )
	debugger? (
		gtk3? ( x11-libs/vte:2.91 )
		!gtk3? ( x11-libs/vte:0 )
		)
	enchant? ( app-text/enchant:= )
	git? ( dev-libs/libgit2:= )
	gpg? ( app-crypt/gpgme:1= )
	gtkspell? (
		gtk3? ( app-text/gtkspell:3= )
		!gtk3? ( app-text/gtkspell:2 )
		)
	lua? ( dev-lang/lua:0= )
	markdown? (
		app-text/discount
		net-libs/webkit-gtk:4
		)
	pretty-printer? ( dev-libs/libxml2:2 )
	scope? (
		gtk3? ( x11-libs/vte:2.91 )
		!gtk3? ( x11-libs/vte:0 )
		)
	soup? ( net-libs/libsoup:2.4 )
	workbench? ( dev-libs/libgit2:= )
"
RDEPEND="${DEPEND}
	scope? ( sys-devel/gdb )
"
BDEPEND="virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=( "${FILESDIR}"/${P}-libgit2-0.99.patch )

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
		$(use_enable !gtk3 geanydoc)
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
