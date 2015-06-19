# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libxsettings-client/libxsettings-client-0.17-r1.ebuild,v 1.1 2014/07/01 23:38:10 jer Exp $

EAPI=5
GPE_TARBALL_SUFFIX="bz2"
inherit autotools eutils gpe

DESCRIPTION="XSETTINGS client code"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~sh ~x86"
IUSE="static-libs"

DOCS=( ChangeLog )

DEPEND="
	${DEPEND}
	x11-proto/xproto
	x11-libs/libX11
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e 's|INCLUDES = -I $(includedir)|INCLUDES = -I $(ROOT)/$(includedir)|' \
		Makefile.am || die
	sed -i -e '/^CFLAGS="-Os -Wall"/d' configure.ac || die
	eautoreconf
}

src_configure() {
	# override gpe_src_configure() bug #515340
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
