# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF="1"
inherit eutils autotools-multilib ltprune

DESCRIPTION="Libconfig is a simple library for manipulating structured configuration files"
HOMEPAGE="http://www.hyperrealm.com/libconfig/libconfig.html"
SRC_URI="http://www.hyperrealm.com/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~mips ppc ~ppc64 s390 sparc x86 ~x86-linux"
IUSE="+cxx examples static-libs"

DEPEND="
	sys-devel/libtool
	sys-devel/bison"

PATCHES=( "${FILESDIR}/${PN}-1.5-out-of-source-build.patch" )

src_prepare() {
	sed -i configure.ac -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' || die
	autotools-multilib_src_prepare
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable cxx)
		--disable-examples
	)
	autotools-utils_src_configure
}

multilib_src_test() {
	# It responds to check but that does not work as intended
	emake test
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files

	if use examples; then
		find examples -name "Makefile.*" -delete || die
		dodoc -r examples
	fi
}
