# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit versionator

DESCRIPTION="A massively-parallel software build system implemented on top of GNU make"
HOMEPAGE="http://www.codesynthesis.com/projects/build/"
SLOT="0"
SRC_URI="http://www.codesynthesis.com/download/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="examples"

DEPEND=""
RDEPEND=""

src_install() {
	emake install_prefix="${ED%/}/usr" install

	HTML_DOCS=( documentation/*.{css,xhtml} )
	einstalldocs
	dodoc documentation/[[:upper:]]*

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
