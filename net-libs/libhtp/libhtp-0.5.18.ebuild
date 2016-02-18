# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit multilib-minimal

MY_P=${P#lib}

DESCRIPTION="security-aware parser for the HTTP protocol and the related bits and pieces"
HOMEPAGE="https://github.com/OISF/libhtp"
SRC_URI="https://github.com/OISF/${PN}/releases/download/${PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
IUSE="debug static-libs"

RDEPEND="sys-libs/zlib[static-libs?]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

multilib_src_configure() {
	# The debug configure logic is broken.
	ECONF_SOURCE=${S} \
	econf \
		$(usex debug '--enable-debug' '') \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	use static-libs || find "${ED}" -name '*.la' -delete
}
