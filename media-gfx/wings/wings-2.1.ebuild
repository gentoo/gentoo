# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit multilib

DESCRIPTION="Wings 3D is an advanced subdivision modeler"
HOMEPAGE="http://www.wings3d.com/"
SRC_URI="mirror://sourceforge/wings/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-lang/erlang-18.1[smp,wxwidgets]
	dev-libs/cl
	media-libs/libsdl[opengl]
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1-wx.patch
)

src_prepare() {
	default

	sed -i \
		-e '/include_lib/s|"wings/|"../|' \
		$(find . -name '*'.erl) \
		|| die
}

src_configure() {
	export ERL_PATH="/usr/$(get_libdir)/erlang/lib/"
}

src_compile() {
	# Work around parallel make issues
	emake vsn.mk
	for subdir in intl_tools src e3d icons plugins_src; do
		emake -C ${subdir}
	done
}

src_install() {
	WINGS_PATH=${ERL_PATH}/${P}
	dodir ${WINGS_PATH}

	find -name 'Makefile*' -exec rm -f '{}' \;

	insinto ${WINGS_PATH}
	doins -r e3d ebin icons plugins psd shaders src textures tools

	newbin "${FILESDIR}"/wings.sh-r1 wings
	dodoc AUTHORS README
}
