# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

MY_P="${P/_/s}"

DESCRIPTION="A graphical user interface toolkit for X"
HOMEPAGE="http://www.nongnu.org/xforms/"
SRC_URI="http://savannah.nongnu.org/download/xforms/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="doc opengl static-libs"

RDEPEND="virtual/jpeg
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXpm
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}
	x11-proto/xproto"

S=${WORKDIR}/${MY_P}

DOCS=( ChangeLog NEWS README )

src_prepare() {
	rm "${S}"/config/libtool.m4 "${S}"/acinclude.m4
	AT_M4DIR=config eautoreconf
}

src_configure() {
	econf \
		$(use_enable doc docs) \
		$(use_enable opengl gl) \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
