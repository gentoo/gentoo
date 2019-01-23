# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6,3_7} )
CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake-utils gnome2-utils python-single-r1

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/weechat/weechat.git"
else
	SRC_URI="https://weechat.org/files/src/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~x86 ~x64-macos"
fi

DESCRIPTION="Portable and multi-interface IRC client"
HOMEPAGE="https://weechat.org/"

LICENSE="GPL-3"
SLOT="0"

NETWORKS="+irc"
PLUGINS="+alias +buflist +charset +exec +fset +fifo +logger +relay +scripts +spell +trigger +xfer"
# dev-lang/v8 was dropped from Gentoo so we can't enable javascript support
SCRIPT_LANGS="guile lua +perl php +python ruby tcl"
LANGS=" cs de es fr hu it ja pl pt pt_BR ru tr"
IUSE="doc nls +ssl test ${SCRIPT_LANGS} ${PLUGINS} ${INTERFACES} ${NETWORKS}"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/libgcrypt:0=
	net-misc/curl[ssl]
	sys-libs/ncurses:0=
	sys-libs/zlib
	charset? ( virtual/libiconv )
	guile? ( >=dev-scheme/guile-2.0 )
	lua? ( dev-lang/lua:0[deprecated] )
	nls? ( virtual/libintl )
	perl? ( dev-lang/perl:= )
	php? ( >=dev-lang/php-7.0:* )
	python? ( ${PYTHON_DEPS} )
	ruby? ( || ( dev-lang/ruby:2.5 dev-lang/ruby:2.4 dev-lang/ruby:2.3 ) )
	ssl? ( net-libs/gnutls )
	spell? ( app-text/aspell )
	tcl? ( >=dev-lang/tcl-8.4.15:0= )
"
DEPEND="${RDEPEND}
	doc? (
		>=dev-ruby/asciidoctor-1.5.4
		dev-util/source-highlight
	)
	nls? ( >=sys-devel/gettext-0.15 )
	test? ( dev-util/cpputest )
"

DOCS="AUTHORS.adoc ChangeLog.adoc Contributing.adoc ReleaseNotes.adoc README.adoc"

# tests need to be fixed to not use system plugins if weechat is already installed
RESTRICT="test"

PATCHES=( "${FILESDIR}"/${PN}-2.2-tinfo.patch )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	# fix libdir placement
	sed -i \
		-e "s:lib/:$(get_libdir)/:g" \
		-e "s:lib\":$(get_libdir)\":g" \
		CMakeLists.txt || die "sed failed"

	# install only required translations
	local i
	for i in ${LANGS} ; do
		if ! has ${i} ${LINGUAS-${i}} ; then
			sed -i \
				-e "/${i}.po/d" \
				po/CMakeLists.txt || die
		fi
	done

	# install only required documentation ; en always
	for i in $(grep add_subdirectory doc/CMakeLists.txt \
			| sed -e 's/.*add_subdirectory(\(..\)).*/\1/' -e '/en/d'); do
		if ! has ${i} ${LINGUAS-${i}} ; then
			sed -i \
				-e '/add_subdirectory('${i}')/d' \
				doc/CMakeLists.txt || die
		fi
	done

	# install docs in correct directory
	sed -i "s#\${SHAREDIR}/doc/\${PROJECT_NAME}#\0-${PV}/html#" doc/*/CMakeLists.txt || die

	if [[ ${CHOST} == *-darwin* ]]; then
		# fix linking error on Darwin
		sed -i "s/+ get_config_var('LINKFORSHARED')//" \
			cmake/FindPython.cmake || die
		# allow to find the plugins by default
		sed -i 's/".so,.dll"/".bundle,.so,.dll"/' \
			src/core/wee-config.c || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_NCURSES=ON
		-DENABLE_NLS=$(usex nls)
		-DENABLE_GNUTLS=$(usex ssl)
		-DENABLE_LARGEFILE=ON
		-DENABLE_ALIAS=$(usex alias)
		-DENABLE_ASPELL=$(usex spell)
		-DENABLE_BUFLIST=$(usex buflist)
		-DENABLE_CHARSET=$(usex charset)
		-DENABLE_EXEC=$(usex exec)
		-DENABLE_FSET=$(usex fset)
		-DENABLE_FIFO=$(usex fifo)
		-DENABLE_IRC=$(usex irc)
		-DENABLE_LOGGER=$(usex logger)
		-DENABLE_RELAY=$(usex relay)
		-DENABLE_SCRIPT=$(usex scripts)
		-DENABLE_SCRIPTS=$(usex scripts)
		-DENABLE_PERL=$(usex perl)
		-DENABLE_PHP=$(usex php)
		-DENABLE_PYTHON=$(usex python)
		-DENABLE_RUBY=$(usex ruby)
		-DENABLE_LUA=$(usex lua)
		-DENABLE_TCL=$(usex tcl)
		-DENABLE_GUILE=$(usex guile)
		-DENABLE_JAVASCRIPT=OFF
		-DENABLE_TRIGGER=$(usex trigger)
		-DENABLE_XFER=$(usex xfer)
		-DENABLE_DOC=$(usex doc)
		-DENABLE_TESTS=$(usex test)
	)

	if use python; then
		python_export PYTHON_LIBPATH
		mycmakeargs+=(
			-DPYTHON_EXECUTABLE="${PYTHON}"
			-DPYTHON_LIBRARY="${PYTHON_LIBPATH}"
		)
	fi

	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
