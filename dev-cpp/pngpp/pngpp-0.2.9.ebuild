# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P=${P/pp/++}

DESCRIPTION="A simple but powerful C++ interface to libpng"
HOMEPAGE="http://www.nongnu.org/pngpp/"
SRC_URI="mirror://nongnu/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/libpng:0"
DEPEND=""

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${PN}-0.2.9-DESTDIR.patch )

src_compile() { :; }
src_test() { :; }

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install-headers
	einstalldocs

	docinto examples
	dodoc example/*.cpp
	docompress -x /usr/share/doc/${PF}/examples
}
