# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils ltprune multilib-minimal

DESCRIPTION="Libconfig is a simple library for manipulating structured configuration files"
HOMEPAGE="
	http://www.hyperrealm.com/libconfig/libconfig.html
	https://github.com/hyperrealm/libconfig
"
SRC_URI="https://github.com/hyperrealm/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/11"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-linux"
IUSE="+cxx static-libs"

DEPEND="
	sys-apps/texinfo
	sys-devel/bison
	sys-devel/libtool
"

src_prepare() {
	default
	sed -i \
		-e '/sleep 3/d' \
		-e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' \
		configure.ac || die
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		$(use_enable cxx) \
		$(use_enable static-libs static) \
		--disable-examples
}

multilib_src_test() {
	# It responds to check but that does not work as intended
	emake test
}

multilib_src_install() {
	default

	prune_libtool_files
}
