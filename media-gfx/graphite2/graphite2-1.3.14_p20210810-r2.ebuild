# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=80c52493ef42e6fe605a69dcddd2a691cd8a1380
GENTOO_DEPEND_ON_PERL="no"
PYTHON_COMPAT=( python3_{9..11} )
inherit perl-module python-any-r1 cmake-multilib

DESCRIPTION="Library providing rendering capabilities for complex non-Roman writing systems"
HOMEPAGE="https://scripts.sil.org/cms/scripts/page.php?site_id=projects&item_id=graphite_home"
SRC_URI="https://github.com/silnrsi/graphite/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/graphite-${COMMIT}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="perl test"
RESTRICT="!test? ( test )"

RDEPEND="perl? ( dev-lang/perl:= )"
DEPEND="${RDEPEND}
	test? ( dev-libs/glib:2 )
"
BDEPEND="
	perl? (
		dev-lang/perl
		dev-perl/Locale-Maketext-Lexicon
		dev-perl/Module-Build
	)
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/fonttools[${PYTHON_USEDEP}]')
		media-libs/fontconfig
		perl? ( virtual/perl-Test-Simple )
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.3.5-includes-libs-perl.patch"
	"${FILESDIR}/${PN}-1.3.14-fix-cmake-files-libdir.patch"
	"${FILESDIR}/${PN}-1.3.14-no-libtool-file.patch"
	"${FILESDIR}/${PN}-1.3.14-fix-nodefaultlibs-deux.patch"
)

pkg_setup() {
	use perl && perl_set_version
	use test && python-any-r1_pkg_setup
}

python_check_deps() {
	has_version -b "dev-python/fonttools[${PYTHON_USEDEP}]"
}

src_prepare() {
	cmake_src_prepare
	use test || cmake_comment_add_subdirectory tests
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

	if use elibc_musl ; then
		# bug #829690
		if use ppc || use x86 ; then
			sed -e 's:${GRAPHITE_LINK_FLAGS}:-lssp_nonshared &:' \
				-i "${S}"/src/CMakeLists.txt || die
		fi
	fi

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
}
