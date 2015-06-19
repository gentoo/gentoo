# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libpano13/libpano13-2.9.19.ebuild,v 1.2 2014/12/22 10:08:25 pinkbyte Exp $

EAPI="5"

inherit versionator java-pkg-opt-2 eutils

DESCRIPTION="Helmut Dersch's panorama toolbox library"
HOMEPAGE="http://panotools.sourceforge.net/"
SRC_URI="mirror://sourceforge/panotools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/3"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="java static-libs"

DEPEND="media-libs/libpng:0=
	media-libs/tiff:0
	sys-libs/zlib
	virtual/jpeg:0
	java? ( >=virtual/jdk-1.3 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-$(get_version_component_range 1-3)"

src_configure() {
	LIBS="-lm" econf \
		$(use_with java java ${JAVA_HOME}) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README README.linux AUTHORS NEWS doc/*.txt

	if ! use static-libs ; then
		prune_libtool_files
	fi
}
