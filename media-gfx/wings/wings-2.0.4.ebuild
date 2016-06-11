# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils multilib

DESCRIPTION="Wings 3D is an advanced subdivision modeler"
HOMEPAGE="http://www.wings3d.com/"
SRC_URI="mirror://sourceforge/wings/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-lang/erlang-18.1[wxwidgets]
	dev-libs/cl
	media-libs/libsdl[opengl]
"
DEPEND="${RDEPEND}"

src_configure() {
	export ERL_PATH="/usr/$(get_libdir)/erlang/lib/"
	export ESDL_PATH="${ERL_PATH}/$(best_version media-libs/esdl | cut -d/ -f2)"
}

src_compile() {
	# Work around parallel make issues
	emake vsn.mk
	for subdir in intl_tools src fonts_src e3d icons plugins_src; do
		emake ESDL_PATH="${ESDL_PATH}" -C ${subdir}
	done
}

src_install() {
	WINGS_PATH=${ERL_PATH}/${P}
	dodir ${WINGS_PATH}

	find -name 'Makefile*' -exec rm -f '{}' \;

	insinto ${WINGS_PATH}
	doins -r e3d ebin fonts icons plugins psd shaders src textures tools

	dosym ${WINGS_PATH} ${ERL_PATH}/${PN}
	dosym ${ESDL_PATH} ${ERL_PATH}/esdl
	newbin "${FILESDIR}"/wings.sh wings
	dodoc AUTHORS README
}
