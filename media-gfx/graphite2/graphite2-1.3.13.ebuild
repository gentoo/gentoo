# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

CMAKE_ECLASS=cmake
GENTOO_DEPEND_ON_PERL="no"
inherit perl-module python-any-r1 cmake-multilib

DESCRIPTION="Library providing rendering capabilities for complex non-Roman writing systems"
HOMEPAGE="https://scripts.sil.org/cms/scripts/page.php?site_id=projects&item_id=graphite_home"
SRC_URI="mirror://sourceforge/silgraphite/${PN}/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="perl test"
RESTRICT="!test? ( test )"

RDEPEND="
	perl? ( dev-lang/perl:= )
"
DEPEND="${RDEPEND}
	perl? (
		dev-perl/Locale-Maketext-Lexicon
		dev-perl/Module-Build
	)
	test? (
		${PYTHON_DEPS}
		dev-libs/glib:2
		$(python_gen_any_dep 'dev-python/fonttools[${PYTHON_USEDEP}]')
		media-libs/fontconfig
		perl? ( virtual/perl-Test-Simple )
	)
"

PATCHES=( "${FILESDIR}/${PN}-1.3.5-includes-libs-perl.patch" )

pkg_setup() {
	use perl && perl_set_version
	use test && python-any-r1_pkg_setup
}

python_check_deps() {
	has_version "dev-python/fonttools[${PYTHON_USEDEP}]"
}

src_prepare() {
	cmake_src_prepare

	# make tests optional
	if ! use test; then
		sed -e '/tests/d' -i CMakeLists.txt || die
	fi
}

multilib_src_configure() {
	local mycmakeargs=(
		# Renamed VM_MACHINE_TYPE to GRAPHITE2_VM_TYPE
		-DGRAPHITE2_VM_TYPE=direct
	)
	# https://sourceforge.net/p/silgraphite/bugs/49/
	[[ ${CHOST} == powerpc*-apple* ]] && mycmakeargs+=(
		-DGRAPHITE2_NSEGCACHE:BOOL=ON
	)

	cmake_src_configure

	# fix perl linking
	if multilib_is_native_abi && use perl; then
		# we rely on the fact that cmake_src_configure sets BUILD_DIR
		sed -e "s:@BUILD_DIR@:\"${BUILD_DIR}/src\":" \
			-i "${S}"/contrib/perl/Build.PL || die
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
		cmake_src_test
	else
		einfo "Cannot test since python is not multilib."
	fi
}

src_test() {
	cmake-multilib_src_test
	if use perl; then
		# Perl tests fail due to missing POD coverage...
		perl_rm_files "contrib/perl/t/pod.t" "contrib/perl/t/pod-coverage.t"
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

	find "${ED}" \( -name '*.a' -o -name '*.la' \) -delete || die
}
