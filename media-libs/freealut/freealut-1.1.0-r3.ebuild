# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils autotools multilib-minimal

DESCRIPTION="The OpenAL Utility Toolkit"
HOMEPAGE="http://www.openal.org/"
SRC_URI="http://connect.creativelabs.com/openal/Downloads/ALUT/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="
	>=media-libs/openal-1.15.1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	# Link against openal and pthread
	sed -i -e 's/libalut_la_LIBADD = .*/& -lopenal -lpthread/' src/Makefile.am
	AT_M4DIR="${S}/admin/autotools/m4" eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} econf \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	dohtml doc/*
	prune_libtool_files
}
