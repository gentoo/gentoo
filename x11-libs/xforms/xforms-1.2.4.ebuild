# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

MY_P="${P/-/_}"

DESCRIPTION="A graphical user interface toolkit for X"
HOMEPAGE="http://xforms-toolkit.org/"
SRC_URI="https://dev.gentoo.org/~monsieurp/packages/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="doc opengl static-libs"

RDEPEND="
	virtual/jpeg:0=
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXpm
	opengl? ( virtual/opengl )"

DEPEND="
	${RDEPEND}
	x11-proto/xproto"

S="${WORKDIR}/${MY_P}"

DOCS=( ChangeLog README )

src_prepare() {
	default
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
