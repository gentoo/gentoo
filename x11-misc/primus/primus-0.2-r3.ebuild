# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-build

DESCRIPTION="Faster OpenGL offloading for Bumblebee"
HOMEPAGE="https://github.com/amonakov/primus"
SRC_URI="https://github.com/amonakov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
EGIT_REPO_URI="https://github.com/amonakov/${PN}.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+libglvnd"

RDEPEND="
	x11-misc/bumblebee
	x11-drivers/nvidia-drivers[libglvnd(+)=]
"
DEPEND="virtual/opengl"

PATCHES=(
	"${FILESDIR}/primus-0.2-libglvnd-workaround.patch"
	"${FILESDIR}/primus-0.2-respect-ldflags.patch"
)

src_prepare() {
	default
	# Exported values don't always seem to be used.  Until source fixed,
	# patch primusrun script
	if use libglvnd; then
		sed -i "/libGLa/a export PRIMUS_libGLa='\/usr\/\$LIB\/libGLX_nvidia.so.0'" primusrun || die
		sed -i "/libGLd/a export PRIMUS_libGLd='\/usr\/\$LIB\/libGLX.so.0'" primusrun || die
	else
		sed -i "/libGLa/a export PRIMUS_libGLa='\/usr\/$$LIB\/opengl\/nvidia\/lib/libGL.so.1'" primusrun || die
	fi
}

src_compile() {
	if use libglvnd; then
		export PRIMUS_libGLa='/usr/$$LIB/libGLX_nvidia.so.0'
		export PRIMUS_libGLd='/usr/$$LIB/libGLX.so.0'
	else
		export PRIMUS_libGLa='/usr/$$LIB/opengl/nvidia/lib/libGL.so.1'
	fi
	mymake() {
		emake LIBDIR=$(get_libdir)
	}
	multilib_parallel_foreach_abi mymake
}

src_install() {
	sed -i -e "s#^PRIMUS_libGL=.*#PRIMUS_libGL='/usr/\$LIB/primus'#" primusrun
	dobin primusrun
	myinst() {
		insinto /usr/$(get_libdir)/primus
		doins "${S}"/$(get_libdir)/libGL.so.1
	}
	multilib_foreach_abi myinst
}
