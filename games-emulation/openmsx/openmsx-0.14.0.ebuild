# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit desktop python-any-r1 readme.gentoo-r1

DESCRIPTION="MSX emulator that aims for perfection"
HOMEPAGE="http://openmsx.org/"
SRC_URI="https://github.com/openMSX/openMSX/releases/download/RELEASE_${PV//./_}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="
	dev-lang/tcl:0=
	dev-libs/libxml2
	media-libs/libpng:0=
	media-libs/libsdl[sound,video]
	>=media-libs/glew-1.3.2:0=
	media-libs/sdl-image[png]
	media-libs/sdl-ttf
	virtual/opengl
"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
"

PATCHES=(
	"${FILESDIR}"/sdl-ttf.patch
)

DOC_CONTENTS="
If you want to if you want to emulate real MSX systems and not
only the free C-BIOS machines, put the system ROMs in one of
the following directories: /usr/share/${PN}/systemroms
or ~/.openMSX/share/systemroms
"

src_prepare() {
	default
	sed -i \
		-e '/^LDFLAGS:=/d' \
		-e '/LINK_FLAGS_PREFIX/d' \
		-e '/LINK_FLAGS+=/s/-s//' \
		-e '/LINK_FLAGS+=\$(TARGET_FLAGS)/s/$/ $(LDFLAGS)/' \
		build/main.mk \
		|| die
	sed -i -e '/SYMLINK/s:true:false:' build/custom.mk || die
	sed -i -e 's/GPL.txt//' doc/node.mk || die
}

src_compile() {
	emake \
		CXXFLAGS="${CXXFLAGS}" \
		INSTALL_SHARE_DIR=/usr/share/${PN} \
		V=1
}

src_install() {
	emake \
		V=1 \
		INSTALL_BINARY_DIR="${ED}/usr/bin" \
		INSTALL_SHARE_DIR="${ED}/usr/share/${PN}" \
		INSTALL_DOC_DIR="${D}"/usr/share/doc/${PF} \
		install

	einstalldocs
	readme.gentoo_create_doc

	for i in 16 32 48 64 128 256 ; do
		newicon -s "${i}" "share/icons/openMSX-logo-${i}.png" "${PN}.png"
	done
	make_desktop_entry "${PN}" "openMSX"
}

pkg_postinst() {
	readme.gentoo_print_elog
}
