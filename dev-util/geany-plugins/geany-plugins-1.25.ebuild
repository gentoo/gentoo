# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit autotools-utils python-single-r1 vala versionator

DESCRIPTION="A collection of different plugins for Geany"
HOMEPAGE="http://plugins.geany.org/geany-plugins"
SRC_URI="http://plugins.geany.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+autoclose +automark +commander ctags debugger +defineformat devhelp enchant git gpg gtkspell lua markdown multiterm nls +overview python scope soup webkit"

LINGUAS="be ca da de es fr gl ja pt pt_BR ru tr zh_CN"

COMMON_DEPEND=">=dev-util/geany-$(get_version_component_range 1-2)
	autoclose? ( x11-libs/gtk+:2 )
	commander? ( x11-libs/gtk+:2 )
	defineformat? ( x11-libs/gtk+:2 )
	dev-libs/libxml2:2
	dev-libs/glib:2
	ctags? ( dev-util/ctags )
	debugger? (
		x11-libs/vte:0
		dev-util/geany[-gtk3]
		)
	devhelp? (
		dev-util/devhelp
		gnome-base/gconf:2
		net-libs/webkit-gtk:2
		x11-libs/gtk+:2
		x11-libs/libwnck:1
		)
	enchant? ( app-text/enchant )
	gpg? ( app-crypt/gpgme )
	git? ( <dev-libs/libgit2-0.23.0 )
	gtkspell? ( app-text/gtkspell:2 )
	lua? ( =dev-lang/lua-5.1*:= )
	markdown? (
		app-text/discount
		net-libs/webkit-gtk:2
		x11-libs/gtk+:2
		)
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
	soup? ( net-libs/libsoup )
	webkit? (
		net-libs/webkit-gtk:2
		x11-libs/gtk+:2
		x11-libs/gdk-pixbuf:2
		)"
RDEPEND="${COMMON_DEPEND}
	scope? ( sys-devel/gdb )"
DEPEND="${COMMON_DEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# bundled lib buster
	rm markdown/peg-markdown/markdown_lib.c || die

	autotools-utils_src_prepare
	use multiterm && vala_src_prepare
}

src_configure() {
	# GeanyGenDoc requires ctpl which isn’t yet in portage
	local myeconfargs=(
		--docdir=/usr/share/doc/${PF}
		--disable-cppcheck
		--disable-extra-c-warnings
		--disable-geanygendoc
		# peg-markdown is bundled, use app-text/discount instead
		--disable-peg-markdown
		--enable-geanymacro
		--enable-geanynumberedbookmarks
		--enable-projectorganizer
		--enable-pretty-printer
		--enable-tableconvert
		--enable-treebrowser
		--enable-xmlsnippets
		$(use_enable autoclose)
		$(use_enable automark)
		$(use_enable commander)
		$(use_enable ctags geanyctags)
		$(use_enable debugger)
		$(use_enable defineformat)
		$(use_enable devhelp)
		$(use_enable enchant spellcheck)
		$(use_enable gpg geanypg)
		$(use_enable git gitchangebar)
		$(use_enable gtkspell)
		$(use_enable markdown)
		$(use_enable multiterm)
		$(use_enable lua geanylua)
		$(use_enable nls)
		$(use_enable overview)
		$(use_enable python geanypy)
		$(use_enable scope)
		# Having updatechecker… when you’re using a package manager?
		$(use_enable soup updatechecker)
		$(use_enable soup geniuspaste)
		$(use_enable webkit webhelper)
	)

	autotools-utils_src_configure
}
