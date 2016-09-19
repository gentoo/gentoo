# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils multilib-minimal

DESCRIPTION="A simple non-validating CSS 1 and HTML parser for C++"
HOMEPAGE="http://htmlcxx.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="sys-devel/flex[${MULTILIB_USEDEP}]
	virtual/yacc"

PATCHES=(
	"${FILESDIR}"/0001-strstream-is-deprecated-use-sstream-instead.patch
	"${FILESDIR}"/0002-Update-css_syntax.y-for-use-with-less-ancient-Bison.patch
)

ECONF_SOURCE="${S}"

multilib_src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	prune_libtool_files
	einstalldocs
}
