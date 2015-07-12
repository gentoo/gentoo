# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/facter/facter-3.0.1-r2.ebuild,v 1.1 2015/07/11 23:21:40 binki Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit cmake-utils ruby-ng

DESCRIPTION="A cross-platform Ruby library for retrieving facts from operating systems"
HOMEPAGE="http://www.puppetlabs.com/puppet/related-projects/facter/"
SRC_URI="https://downloads.puppetlabs.com/facter/${P}.tar.gz"
S="${S}/all/${P}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="debug test"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

CDEPEND="
	>=sys-devel/gcc-4.8:*
	>=dev-libs/boost-1.54
	>=dev-cpp/yaml-cpp-0.5.1
	dev-libs/openssl:=
	sys-apps/util-linux
	app-emulation/virt-what
	net-misc/curl"

RDEPEND+=" ${CDEPEND}"
DEPEND+=" test? ( ${CDEPEND} )"

src_prepare() {
	sed -i 's/\-Werror\ //g' "vendor/leatherman/cmake/cflags.cmake" || die
	# Remove the code that installs facter.rb to the wrong directory.
	sed -i -e '/RUBY_VENDORDIR/d' lib/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
	  -DCXXFLAGS="-Wno-error"
		-DCXX_FLAGS="-Wno-error"
		-DCMAKE_CXX_FLAGS:STRING='-march=native -O2 -pipe -Wno-error '
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCMAKE_BUILD_TYPE=None
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_INSTALL_SYSCONFDIR=/etc
		-DCMAKE_INSTALL_LOCALSTATEDIR=/var
	)
	if use debug; then
		mycmakeargs+=(
		  -DCMAKE_BUILD_TYPE=Debug
		)
	fi
	cmake-utils_src_configure
}

each_ruby_install() {
	doruby "${BUILD_DIR}"/lib/facter.rb
}

src_install() {
	cmake-utils_src_install
	ruby-ng_src_install
}
