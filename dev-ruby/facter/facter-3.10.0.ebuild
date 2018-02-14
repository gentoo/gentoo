# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

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
	S="${S}/${P}"
else
	[[ "${PV}" = *_rc* ]] || \
	KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
	SRC_URI="https://github.com/puppetlabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${S}/all/${P}"
fi

BDEPEND="
	>=sys-devel/gcc-4.8:*
	>=dev-libs/leatherman-1.0.0
	dev-cpp/cpp-hocon"
CDEPEND="
	dev-libs/openssl:*
	sys-apps/util-linux
	app-emulation/virt-what
	net-misc/curl
	>=dev-libs/boost-1.54[nls]
	>=dev-cpp/yaml-cpp-0.5.1
	!<app-admin/puppet-4.0.0"

ruby_add_bdepend "test? ( dev-ruby/rake dev-ruby/rspec:2 dev-ruby/mocha:0.14 )"

RDEPEND="${CDEPEND}"
DEPEND="${BDEPEND}
	${CDEPEND}"

src_prepare() {
	# Remove the code that installs facter.rb to the wrong directory.
	sed -i '/install(.*facter\.rb/d' lib/CMakeLists.txt || die
	sed -i '/install(.*facter\.jar/d' lib/CMakeLists.txt || die
	# make it support multilib
	sed -i "s/\ lib)/\ $(get_libdir))/g" lib/CMakeLists.txt || die
	sed -i "s/lib\")/$(get_libdir)\")/g" CMakeLists.txt || die
	# make the require work
	sed -i 's/\${LIBFACTER_INSTALL_DESTINATION}\///g' lib/facter.rb.in || die
	# be explicit about the version of rspec we test with and use the
	# correct lib directory for tests
	sed -i -e '/libfacter.*specs/ s/rspec/rspec-2/' \
		-e '/libfacter.*specs/ s/lib64/lib/' CMakeLists.txt || die
	# be more lenient for software versions for tests
	sed -i -e '/rake/ s/~> 10.1.0/>= 10/' \
		-e '/rspec/ s/2.11.0/2.11/' \
		-e '/mocha/ s/0.10.5/0.14.0/' lib/Gemfile || die
	# patches
	default
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCMAKE_BUILD_TYPE=None
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_INSTALL_SYSCONFDIR=/etc
		-DCMAKE_INSTALL_LOCALSTATEDIR=/var
		-DUSE_JRUBY_SUPPORT=FALSE
		-DBLKID_LIBRARY=/$(get_libdir)/libblkid.so.1
	)
	if use debug; then
		mycmakeargs+=(
		  -DCMAKE_BUILD_TYPE=Debug
		)
	fi
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

each_ruby_install() {
	doruby "${BUILD_DIR}"/lib/facter.rb
}

src_test() {
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install
	ruby-ng_src_install

	# need a variable file in env.d :(
	diropts -m0755
	dodir /etc/env.d
	echo -n "FACTERDIR=/usr/$(get_libdir)" > "${D}/etc/env.d/00facterdir"
	fperms 0644 /etc/env.d/00facterdir
}
