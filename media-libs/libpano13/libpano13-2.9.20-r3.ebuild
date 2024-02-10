# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit java-pkg-opt-2

DESCRIPTION="Helmut Dersch's panorama toolbox library"
HOMEPAGE="http://panotools.sourceforge.net/"
SRC_URI="mirror://sourceforge/panotools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/3"
KEYWORDS="amd64 arm64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="java static-libs"

DEPEND="media-libs/libpng:=
	media-libs/tiff:=
	media-libs/libjpeg-turbo:=
	sys-libs/zlib
	java? ( >=virtual/jdk-1.8:* )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-$(ver_cut 1-3)"

src_configure() {
	LIBS="-lm" econf \
		$(use_with java java ${JAVA_HOME}) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README README.linux AUTHORS NEWS doc/*.txt

	if ! use static-libs ; then
		find "${D}" -name '*.la' -delete || die
	fi
}
