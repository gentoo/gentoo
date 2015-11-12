# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

# Switch to ^g when we switch to EAPI=6.
MY_P="G${P:1}"

DESCRIPTION="OpenGL binding for Gauche"
HOMEPAGE="http://practical-scheme.net/gauche/"
SRC_URI="mirror://sourceforge/gauche/${MY_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE="cg examples"

RDEPEND=">=dev-scheme/gauche-0.9.2
	virtual/opengl
	media-libs/freeglut
	cg? ( media-gfx/nvidia-cg-toolkit )"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"

src_configure() {
	econf $(usex cg --enable-cg "")
}

src_install() {
	default

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples
		dodoc examples/*.scm
		# install simple
		dodoc -r examples/simple
		# install glbook
		dodoc -r examples/glbook
		dodoc -r examples/images
		# install slbook
		dodoc -r examples/slbook
		# install cg examples
		use cg && dodoc -r examples/cg
	fi
}
