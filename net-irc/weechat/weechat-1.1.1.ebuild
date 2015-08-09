# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit python-single-r1 multilib cmake-utils

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/weechat/weechat.git"
else
	SRC_URI="http://${PN}.org/files/src/${P}.tar.bz2"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="Portable and multi-interface IRC client"
HOMEPAGE="http://weechat.org/"

LICENSE="GPL-3"
SLOT="0"

NETWORKS="+irc"
PLUGINS="+alias +charset +exec +fifo +logger +relay +scripts +spell +trigger +xfer"
#INTERFACES="+ncurses gtk"
SCRIPT_LANGS="guile lua +perl +python ruby tcl"
LANGS=" cs de es fr hu it ja pl pt_BR ru tr"
IUSE="doc nls +ssl test ${LANGS// / linguas_} ${SCRIPT_LANGS} ${PLUGINS} ${INTERFACES} ${NETWORKS}"
#REQUIRED_USE=" || ( ncurses gtk )"

RDEPEND="
	dev-libs/libgcrypt:0=
	net-misc/curl[ssl]
	sys-libs/ncurses
	sys-libs/zlib
	charset? ( virtual/libiconv )
	guile? ( dev-scheme/guile:12 )
	lua? ( dev-lang/lua:0[deprecated] )
	nls? ( virtual/libintl )
	perl? ( dev-lang/perl )
	python? ( ${PYTHON_DEPS} )
	ruby? ( >=dev-lang/ruby-1.9 )
	ssl? ( net-libs/gnutls )
	spell? ( app-text/aspell )
	tcl? ( >=dev-lang/tcl-8.4.15:0= )
"
#	ncurses? ( sys-libs/ncurses )
#	gtk? ( x11-libs/gtk+:2 )
DEPEND="${RDEPEND}
	doc? (
		app-text/asciidoc
		dev-util/source-highlight
	)
	nls? ( >=sys-devel/gettext-0.15 )
	test? ( dev-util/cpputest )
"

DOCS="AUTHORS.asciidoc ChangeLog.asciidoc ReleaseNotes.asciidoc README.asciidoc"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	local i

	# fix libdir placement
	sed -i \
		-e "s:lib/:$(get_libdir)/:g" \
		-e "s:lib\":$(get_libdir)\":g" \
		CMakeLists.txt || die "sed failed"

	# install only required translations
	for i in ${LANGS} ; do
		if ! use linguas_${i} ; then
			sed -i \
				-e "/${i}.po/d" \
				po/CMakeLists.txt || die
		fi
	done

	# install only required documentation ; en always
	for i in `grep ADD_SUBDIRECTORY doc/CMakeLists.txt \
			| sed -e 's/.*ADD_SUBDIRECTORY( \(..\) ).*/\1/' -e '/en/d'`; do
		if ! use linguas_${i} ; then
			sed -i \
				-e '/ADD_SUBDIRECTORY( '${i}' )/d' \
				doc/CMakeLists.txt || die
		fi
	done
}

src_configure() {
	# $(cmake-utils_use_enable gtk)
	# $(cmake-utils_use_enable ncurses)
	local mycmakeargs=(
		"-DENABLE_NCURSES=ON"
		"-DENABLE_LARGEFILE=ON"
		"-DENABLE_DEMO=OFF"
		"-DENABLE_GTK=OFF"
		"-DPYTHON_EXECUTABLE=${PYTHON}"
		$(cmake-utils_use_enable alias)
		$(cmake-utils_use_enable doc)
		$(cmake-utils_use_enable charset)
		$(cmake-utils_use_enable exec)
		$(cmake-utils_use_enable fifo)
		$(cmake-utils_use_enable guile)
		$(cmake-utils_use_enable irc)
		$(cmake-utils_use_enable logger)
		$(cmake-utils_use_enable lua)
		$(cmake-utils_use_enable nls)
		$(cmake-utils_use_enable perl)
		$(cmake-utils_use_enable python)
		$(cmake-utils_use_enable relay)
		$(cmake-utils_use_enable ruby)
		$(cmake-utils_use_enable scripts)
		$(cmake-utils_use_enable scripts script)
		$(cmake-utils_use_enable spell ASPELL)
		$(cmake-utils_use_enable ssl GNUTLS)
		$(cmake-utils_use_enable tcl)
		$(cmake-utils_use_enable test TESTS)
		$(cmake-utils_use_enable trigger)
		$(cmake-utils_use_enable xfer)
	)
	[[ ${EPYTHON} == python3* ]] && mycmakeargs+=( $(cmake-utils_use_enable python PYTHON3) )

	cmake-utils_src_configure
}
