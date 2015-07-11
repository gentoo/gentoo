# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/graphite2/graphite2-1.2.4-r1.ebuild,v 1.20 2015/07/11 20:40:13 dilfridge Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

GENTOO_DEPEND_ON_PERL="no"
inherit eutils perl-module python-any-r1 cmake-multilib

DESCRIPTION="Library providing rendering capabilities for complex non-Roman writing systems"
HOMEPAGE="http://graphite.sil.org/"
SRC_URI="mirror://sourceforge/silgraphite/${PN}/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
IUSE="perl test"

RDEPEND="
	perl? ( dev-lang/perl:= )
"
DEPEND="${RDEPEND}
	perl? (
		dev-perl/Module-Build
		dev-perl/Locale-Maketext-Lexicon
		)
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
	cmake-utils_src_prepare

	# make tests optional
	if ! use test; then
		sed -i \
			-e '/tests/d' \
			CMakeLists.txt || die
	fi
}

multilib_src_configure() {
	local mycmakeargs=(
		"-DVM_MACHINE_TYPE=direct"
		# http://sourceforge.net/p/silgraphite/bugs/49/
		$([[ ${CHOST} == powerpc*-apple* ]] && \
			echo "-DGRAPHITE2_NSEGCACHE:BOOL=ON")
	)

	cmake-utils_src_configure

	# fix perl linking
	if multilib_is_native_abi && use perl; then
		_check_build_dir init
		sed -i \
			-e "s:@BUILD_DIR@:\"${BUILD_DIR}/src\":" \
			"${S}"/contrib/perl/Build.PL || die
	fi
}

src_compile() {
	cmake-multilib_src_compile
	if use perl; then
		cd contrib/perl || die
		perl-module_src_configure
		perl-module_src_compile
	fi
}

src_test() {
	cmake-multilib_src_test
	if use perl; then
		cd contrib/perl || die
		perl-module_src_test
	fi
}

src_install() {
	cmake-multilib_src_install
	if use perl; then
		cd contrib/perl || die
		perl-module_src_install
		perl_delete_localpod
	fi

	prune_libtool_files --all
}
