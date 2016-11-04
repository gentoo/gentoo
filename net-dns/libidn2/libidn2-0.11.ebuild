# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils multilib-minimal

DESCRIPTION="An implementation of the IDNA2008 specifications (RFCs 5890, 5891, 5892, 5893)"
HOMEPAGE="https://www.gnu.org/software/libidn/#libidn2"
SRC_URI="mirror://gnu-alpha/libidn/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-3+"
SLOT="0"
KEYWORDS="amd64 arm hppa ~mips ppc ppc64 x86"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}"/${PN}-0.10-examples.patch
	"${FILESDIR}"/${PN}-0.10-Werror.patch
)

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		$(use_enable static-libs static)
}

multilib_src_install() {
	default

	prune_libtool_files
}
