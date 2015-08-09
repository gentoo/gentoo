# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="Nodebrain is a tool to monitor and do event correlation"
HOMEPAGE="http://nodebrain.sourceforge.net/"
SRC_URI="mirror://sourceforge/nodebrain/nodebrain-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static-libs"

CDEPEND="dev-libs/libedit"
DEPEND="
	${CDEPEND}
	dev-lang/perl
	virtual/pkgconfig
	sys-apps/texinfo
"
RDEPEND="
	${CDEPEND}
	!sys-boot/netboot
	!www-apps/nanoblogger
"

S="${WORKDIR}/nodebrain-${PV}"

src_prepare() {
	# fdl.texi is not included in the sources
	sed -i \
		-e '/@include fdl.texi/d' \
		doc/nbTutorial/nbTutorial.texi || die

	epatch "${FILESDIR}"/${PN}-0.8.14-include.patch

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--include=/usr/include
}

src_compile() {
	# Fails at parallel make
	emake -j1
}

src_install() {
	default
	use static-libs || prune_libtool_files
	dodoc AUTHORS NEWS README THANKS sample/*
	dohtml html/*
}
