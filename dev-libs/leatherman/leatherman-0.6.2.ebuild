# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

inherit cmake-utils multilib ruby-ng

DESCRIPTION="A C++ toolkit"
HOMEPAGE="https://github.com/puppetlabs/leatherman"
SRC_URI="https://downloads.puppetlabs.com/facter/${P}.tar.gz"
SRC_URI="https://github.com/puppetlabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${S}/all/${P}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="debug test"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 ~x86"

CDEPEND="
	>=sys-devel/gcc-4.8:*
	>=dev-libs/boost-1.54[nls]
	net-misc/curl"

RDEPEND+=" ${CDEPEND}"
DEPEND+=" test? ( ${CDEPEND} )"

src_prepare() {
	sed -i 's/\-Werror\ //g' "cmake/cflags.cmake" || die
}

src_configure() {
	local mycmakeargs=(
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

src_install() {
	cmake-utils_src_install
}
