# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

GENTOO_DEPEND_ON_PERL="no"
inherit eutils perl-module python-any-r1 cmake-multilib

DESCRIPTION="Library providing rendering capabilities for complex non-Roman writing systems"
HOMEPAGE="http://graphite.sil.org/"
SRC_URI="mirror://sourceforge/silgraphite/${PN}/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
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
		$(python_gen_any_dep '
			dev-python/fonttools[${PYTHON_USEDEP}]
		')
		${PYTHON_DEPS}
		perl? ( virtual/perl-Test-Simple )
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.3.5-includes-libs-perl.patch"
)

pkg_setup() {
	use perl && perl_set_version
	use test && python-any-r1_pkg_setup
}

python_check_deps() {
	has_version "dev-python/fonttools[${PYTHON_USEDEP}]"
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
		# we rely on the fact that cmake-utils_src_configure sets BUILD_DIR
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

multilib_src_test() {
	if multilib_is_native_abi; then
		cmake-utils_src_test
	else
		einfo Cannot test since python is not multilib.
	fi
}

src_test() {
	cmake-multilib_src_test
	if use perl; then
		cd contrib/perl || die
		# SRC_TEST=do
		# Perl tests fail due to missing POD coverage...
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
