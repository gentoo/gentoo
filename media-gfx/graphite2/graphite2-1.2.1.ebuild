# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

GENTOO_DEPEND_ON_PERL="no"
inherit base eutils cmake-utils perl-module python-any-r1

DESCRIPTION="Library providing rendering capabilities for complex non-Roman writing systems"
HOMEPAGE="http://graphite.sil.org/"
SRC_URI="mirror://sourceforge/silgraphite/${PN}/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~s390"
IUSE="perl test"

RDEPEND="
	perl? ( dev-lang/perl:= )
"
DEPEND="${RDEPEND}
	perl? ( dev-perl/Module-Build )
	test? (
		dev-libs/glib:2
		media-libs/fontconfig
		media-libs/silgraphite
		${PYTHON_DEPS}
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.0-includes-libs-perl.patch"
	"${FILESDIR}/${PN}-1.0.2-no_harfbuzz_tests.patch"
	"${FILESDIR}/${PN}-1.0.3-no-test-binaries.patch"
	"${FILESDIR}/${PN}-1.2.0-solaris.patch"
)

pkg_setup() {
	use perl && perl_set_version
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	base_src_prepare

	# fix perl linking
	if use perl; then
		_cmake_check_build_dir init
		sed -i \
			-e "s:@BUILD_DIR@:\"${CMAKE_BUILD_DIR}/src\":" \
			contrib/perl/Build.PL || die
	fi

	# make tests optional
	if ! use test; then
		sed -i \
			-e '/tests/d' \
			CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		"-DVM_MACHINE_TYPE=direct"
		# http://sourceforge.net/p/silgraphite/bugs/49/
		$([[ ${CHOST} == powerpc*-apple* ]] && \
			echo "-DGRAPHITE2_NSEGCACHE:BOOL=ON")
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use perl; then
		cd contrib/perl
		perl-module_src_configure
		perl-module_src_compile
	fi
}

src_test() {
	cmake-utils_src_test
	if use perl; then
		cd contrib/perl
		perl-module_src_test
	fi
}

src_install() {
	cmake-utils_src_install
	if use perl; then
		cd contrib/perl
		perl-module_src_install
		perl_delete_localpod
	fi

	prune_libtool_files --all
}
