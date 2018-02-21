# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools ltprune multilib-minimal

DESCRIPTION="A C library that implements a dynamic array"
HOMEPAGE="http://judy.sourceforge.net/"
SRC_URI="mirror://sourceforge/judy/Judy-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="static-libs"
DOCS=( AUTHORS ChangeLog README )

src_prepare() {
	eapply -p0 "${FILESDIR}/${P}-parallel-make.patch"
	eapply "${FILESDIR}/${P}-gcc49.patch"
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac || die
	eapply_user
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	ECONF_SOURCE=${BUILD_DIR} econf $(use_enable static-libs static)
}

multilib_src_install_all(){
	einstalldocs
	prune_libtool_files
}
