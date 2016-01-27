# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils multilib-minimal

DESCRIPTION="modern style C++ library that provides a simple and easy interface to libxml2"
HOMEPAGE="http://vslavik.github.io/xmlwrapp/"
SRC_URI="https://github.com/vslavik/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="static-libs"

RDEPEND="dev-libs/boost:=[${MULTILIB_USEDEP}]
	dev-libs/libxml2[${MULTILIB_USEDEP}]
	dev-libs/libxslt[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	sys-devel/boost-m4"

DOCS=( AUTHORS NEWS README )

src_prepare() {
	# Unbundle boost.m4
	rm admin/boost.m4 || die

	sed -i -e '/XMLWRAPP_VISIBILITY/d' configure.ac || die

	eapply_user
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	local ECONF_SOURCE=${BUILD_DIR}
	econf $(use_enable static-libs static)
}

multilib_src_install() {
	default_src_install
	prune_libtool_files
}
