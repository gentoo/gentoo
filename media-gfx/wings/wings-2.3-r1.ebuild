# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit toolchain-funcs

DESCRIPTION="Wings 3D is an advanced subdivision modeler"
HOMEPAGE="https://www.wings3d.com/"
SRC_URI="https://downloads.sourceforge.net/wings/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Build fails with >=dev-lang/erlang-28
RDEPEND="
	>dev-lang/erlang-21[wxwidgets]
	<dev-lang/erlang-28
	dev-libs/cl
	media-libs/glu
	media-libs/libsdl[opengl]
	virtual/opengl
	dev-cpp/eigen
	sci-libs/libigl
"
DEPEND="
	${RDEPEND}
"

PATCHES=( "${FILESDIR}"/${P}-nogit.patch )

src_prepare() {
	sed -i -e 's# -Werror##g;s# -O3##g' $(find -name Makefile) || die
	sed -i \
		-e "s|IGL_INCLUDE = .*$|IGL_INCLUDE=-I/usr/include/eigen3|" \
		c_src/Makefile \
		|| die
	default
}

src_compile() {
	export ERL_PATH="/usr/$(get_libdir)/erlang/lib/"
	tc-export CC
	# Work around parallel make issues
	# Set ER_LIBS to the top source directory
	emake vsn.mk
	for subdir in intl_tools e3d src plugins_src icons; do
		emake -C ${subdir} opt ERL_LIBS="${S}"
	done
	default
}

src_install() {
	WINGS_PATH=${ERL_PATH}/${P}
	dodir ${WINGS_PATH}

	find -name 'Makefile*' -exec rm -f '{}' \;

	insinto ${WINGS_PATH}
	doins -r e3d ebin icons plugins priv psd shaders src textures tools

	newbin "${FILESDIR}"/wings.sh-r1 wings
	dodoc AUTHORS
}
