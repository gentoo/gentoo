# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

# git-r3 goes after ruby-ng so that it overrides src_unpack properly
inherit cmake-utils eutils ruby-ng

DESCRIPTION="A cross-platform ruby library for retrieving facts from operating systems"
HOMEPAGE="http://www.puppetlabs.com/puppet/related-projects/facter/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"
if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/puppetlabs/facter.git"
	EGIT_BRANCH="master"
else
	[[ "${PV}" = *_rc* ]] || \
	KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
	SRC_URI="https://github.com/puppetlabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

RESTRICT="!test? ( test )"

ruby_add_bdepend "test? ( dev-ruby/rake dev-ruby/rspec:2 dev-ruby/mocha:0.14 )"

RDEPEND="
	>=dev-cpp/cpp-hocon-0.2.1:=
	>=dev-libs/leatherman-1.0.0:=
	dev-libs/openssl:0=
	sys-apps/util-linux
	app-emulation/virt-what
	net-misc/curl
	dev-libs/boost:=[nls]
	>=dev-cpp/yaml-cpp-0.5.1
	!<app-admin/puppet-4.0.0"
DEPEND="${RDEPEND}"

# restore ${S} and override all phases exported by ruby-ng.eclass
S="${WORKDIR}/${P}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.14.6-fix-static-libcpp-hocon.patch
	# be explicit about the version of rspec we test with
	"${FILESDIR}"/${PN}-3.14.6-explicit-rspec-2.patch
)

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
		-DRUBY_LIB_INSTALL=${my_ruby_sitelibdir}
		-DBLKID_LIBRARYDIR="${EPREFIX}/$(get_libdir)"
	)
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
