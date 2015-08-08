# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit multilib eutils

DESCRIPTION="excellent 3D polygon mesh modeler"
HOMEPAGE="http://www.wings3d.com/"
SRC_URI="mirror://sourceforge/wings/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=dev-lang/erlang-13.0
	>=media-libs/esdl-1.0.1
	media-libs/libsdl[opengl]"
DEPEND="${RDEPEND}"

pkg_setup() {
	ERL_PATH="/usr/$(get_libdir)/erlang/lib/"
	ESDL_PATH="${ERL_PATH}/$(best_version media-libs/esdl | cut -d/ -f2)"
}

src_compile() {
	make ESDL_PATH="${ERL_PATH}/$(best_version media-libs/esdl | cut -d/ -f2)" || die
}

src_install() {
	WINGS_PATH=${ERL_PATH}/${P}
	dodir ${WINGS_PATH}

	find -name 'Makefile*' -exec rm -f '{}' \;
	for subdir in e3d ebin icons plugins plugins_src src fonts ; do
		cp -r ${subdir} "${D}"/${WINGS_PATH}/ || die
	done

	dosym ${WINGS_PATH} ${ERL_PATH}/${PN}
	dosym ${ESDL_PATH} ${ERL_PATH}/esdl
	newbin "${FILESDIR}"/wings.sh wings
	dodoc AUTHORS README
}
