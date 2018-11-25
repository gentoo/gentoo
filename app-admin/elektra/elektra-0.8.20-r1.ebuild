# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Framework to store config parameters in hierarchical key-value pairs"
HOMEPAGE="https://www.libelektra.org"
SRC_URI="https://www.libelektra.org/ftp/elektra/releases/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
PLUGIN_IUSE="augeas iconv ini simpleini syslog systemd tcl +uname xml yajl";
IUSE="dbus doc static-libs test ${PLUGIN_IUSE}"

RDEPEND="
	dev-libs/libltdl:0
	>=dev-libs/libxml2-2.9.1-r4
	augeas? ( app-admin/augeas )
	dbus? ( >=sys-apps/dbus-1.6.18-r1 )
	iconv? ( >=virtual/libiconv-0-r1 )
	systemd? ( sys-apps/systemd )
	uname? ( sys-apps/coreutils )
	yajl? ( >=dev-libs/yajl-1.0.11-r1 )
"
# 	qt5? (
# 		app-text/discount
# 		dev-qt/qtdeclarative:5
# 		dev-qt/qtgui:5
# 		dev-qt/qttest:5
# 		dev-qt/qtwidgets:5
# 	)
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( >=dev-cpp/gtest-1.7.0 )
"

DOCS=( README.md doc/AUTHORS doc/CODING.md doc/todo/TODO )
# tries to write to user's home directory (and doesn't respect HOME)
RESTRICT="test"

src_prepare() {
	cmake-utils_src_prepare

	einfo remove bundled libs
	# TODO: Remove bundled inih from src/plugins/ini (add to portage):
	# https://code.google.com/p/inih/
	rm -rf src/external || die

	# move doc files to correct location
	sed -e "s/elektra-api/${PF}/" -i cmake/ElektraCache.cmake || die
	sed -e "/^install.*LICENSE/s/^/#DONT /" -i CMakeLists.txt || die

	# avoid useless build time, nothing ends up installed
	cmake_comment_add_subdirectory benchmarks
	cmake_comment_add_subdirectory examples
}

src_configure() {
	# default storage and resolver requirements
	local my_plugins="NONE;dump;resolver;resolver_fm_hpu_b;sync;"
	# defaults chosen by availability in 0.8.16
	my_plugins+="ccode;conditionals;constants;enum;error;filecheck;fstab;glob;"
	my_plugins+="hexcode;hidden;hosts;iterate;keytometa;line;lineendings;list;"
	my_plugins+="logchange;mathcheck;network;ni;null;path;profile;regexstore;"
	my_plugins+="rename;semlock;shell;spec;struct;timeofday;tracer;type;validation;"

	use augeas    && my_plugins+="augeas;"
	use dbus      && my_plugins+="dbus;"
	use iconv     && my_plugins+="iconv;"
	use ini       && my_plugins+="ini;"		# bundles inih
	use simpleini && my_plugins+="simpleini;"
	use syslog    && my_plugins+="syslog;"
	use systemd   && my_plugins+="journald;"
	use tcl       && my_plugins+="tcl;"
	use uname     && my_plugins+="uname;"
	use xml       && my_plugins+="xmltool;"
	use yajl      && my_plugins+="yajl;"

	# Disabling for good (?):
	# counter - Only useful for debugging the plugin framework
	# doc - Explaining basic makeup of a function //bug #514402
	# noresolver - Does not resolve, but can act as one
	# template - Template for new plugin written in C
	# wresolver - Resolver for non-POSIX, e.g. w32/w64 systems
	# my_plugins+=";-counter;-doc;-noresolver;-template;-wresolver"

	local my_tools="kdb"
# 	use qt5 && my_tools+=";qt-gui"

	local mycmakeargs=(
		-DBUILD_PDF=OFF
		-DBUILD_SHARED=ON
		-DBUILD_STATIC=$(usex static-libs)
		-DBUILD_TESTING=$(usex test)
		-DENABLE_TESTING=$(usex test)
		-DPLUGINS=${my_plugins}
		-DTOOLS=${my_tools}
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DTARGET_CMAKE_FOLDER=share/cmake/Modules
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	einfo remove test_data
	rm -rvf "${ED%/}/usr/share/${PN}" || die "Failed to remove test_data"
	einfo remove tool_exec
	rm -rvf "${ED%/}/usr/$(get_libdir)/${PN}/tool_exec" || die "Failed to remove tool_exec"
}
