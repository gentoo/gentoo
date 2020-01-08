# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

# git-r3 goes after ruby-ng so that it overrides src_unpack properly
inherit cmake-utils eutils multilib ruby-ng

DESCRIPTION="A cross-platform ruby library for retrieving facts from operating systems"
HOMEPAGE="http://www.puppetlabs.com/puppet/related-projects/facter/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="debug test"
if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/puppetlabs/facter.git"
	EGIT_BRANCH="master"
else
	[[ "${PV}" = *_rc* ]] || \
	KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
	SRC_URI="https://github.com/puppetlabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

RESTRICT="!test? ( test )"

BDEPEND="
	>=sys-devel/gcc-4.8:*
	dev-cpp/cpp-hocon"
COMMON_DEPEND="
	>=dev-libs/leatherman-1.0.0:=
	dev-libs/openssl:0=
	sys-apps/util-linux
	app-emulation/virt-what
	net-misc/curl
	>=dev-libs/boost-1.54:=[nls]
	>=dev-cpp/yaml-cpp-0.5.1
	!<app-admin/puppet-4.0.0"

ruby_add_bdepend "test? ( dev-ruby/rake dev-ruby/rspec:2 dev-ruby/mocha:0.14 )"

RDEPEND="${COMMON_DEPEND}"
DEPEND="${BDEPEND}
	${COMMON_DEPEND}"

# restore ${S} and override all phases exported by ruby-ng.eclass
S="${WORKDIR}/${P}"

pkg_setup() {
	ruby-ng_pkg_setup
}

src_unpack() {
	default

	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	# be explicit about the version of rspec we test with
	sed -i -e '/libfacter.*specs/ s/rspec/rspec-2/' \
		CMakeLists.txt || die
	# be more lenient for software versions for tests
	sed -i -e '/rake/ s/~> 10.1.0/>= 10/' \
		-e '/rspec/ s/2.11.0/2.11/' \
		-e '/mocha/ s/0.10.5/0.14.0/' lib/Gemfile || die
	# patches
	default
	cmake-utils_src_prepare
}

each_ruby_configure() {
	# hack for correct calculation of relative path from facter.rb to
	# libfacter.so
	my_ruby_sitelibdir=$(ruby_rbconfig_value 'sitelibdir')
}

src_configure() {
	ruby-ng_src_configure

	local mycmakeargs=(
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DRUBY_LIB_INSTALL=${my_ruby_sitelibdir}
		-DBLKID_LIBRARYDIR="${EPREFIX}/$(get_libdir)"
	)
	if use debug; then
		mycmakeargs+=(
		  -DCMAKE_BUILD_TYPE=Debug
		)
	fi
	cmake-utils_src_configure
}

src_compile() {
	addpredict /proc/self/oom_score_adj
	cmake-utils_src_compile
}

src_test() {
	cmake-utils_src_test
}

each_ruby_install() {
	doruby "${BUILD_DIR}"/lib/facter.rb
}

src_install() {
	cmake-utils_src_install
	ruby-ng_src_install
}
