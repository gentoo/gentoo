# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 )

inherit autotools lua-single

DESCRIPTION="A collection of different plugins for Geany"
HOMEPAGE="https://plugins.geany.org"
SRC_URI="https://plugins.geany.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="ctags debugger enchant geniuspaste git gpg gtkspell lsp lua markdown nls pretty-printer scope test webhelper workbench"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/glib:2
	>=dev-util/geany-2.1
	x11-libs/gtk+:3
	ctags? ( dev-util/ctags )
	debugger? ( x11-libs/vte:2.91 )
	enchant? ( app-text/enchant:= )
	geniuspaste? ( net-libs/libsoup:3.0 )
	git? ( dev-libs/libgit2:= )
	gpg? ( app-crypt/gpgme:= )
	gtkspell? ( app-text/gtkspell:3= )
	lsp? (
		>=dev-libs/json-glib-1.10
		>=dev-libs/jsonrpc-glib-3.44
	)
	lua? ( ${LUA_DEPS} )
	markdown? (
		app-text/discount:=
		net-libs/webkit-gtk:4.1
		)
	pretty-printer? ( dev-libs/libxml2:2= )
	scope? ( x11-libs/vte:2.91 )
	webhelper? ( net-libs/webkit-gtk:4.1 )
	workbench? ( dev-libs/libgit2:= )
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-libs/check )
"
RDEPEND="${COMMON_DEPEND}
	scope? ( dev-debug/gdb )
"
BDEPEND="virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_prepare() {
	default
	if ! use test; then
		sed -i "s:gp_have_unittests=yes:gp_have_unittests=no:" build/unittests.m4 || die
	fi
	eautoreconf
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
		$(use_enable geniuspaste)
		$(use_enable gpg geanypg)
		$(use_enable git gitchangebar)
		$(use_enable lsp) --enable-system-jsonrpc
		$(use_enable markdown) --disable-peg-markdown # using app-text/discount instead
		$(use_enable pretty-printer)
		$(use_enable scope)
		$(use_enable enchant spellcheck)
		$(use_enable webhelper)
		$(use_enable workbench)
		# GeanyGenDoc requires ctpl which isn't yet in portage
		--disable-geanygendoc
		# UpdateChecker not required when packaged
		--disable-updatechecker
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
