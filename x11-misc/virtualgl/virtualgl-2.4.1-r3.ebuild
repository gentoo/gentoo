# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-multilib multilib systemd

DESCRIPTION="Run OpenGL applications remotely with full 3D hardware acceleration"
HOMEPAGE="http://www.virtualgl.org/"

MY_PN="VirtualGL"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"
SRC_URI="mirror://sourceforge/${PN}/files/${PV}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1 wxWinLL-3.1 FLTK"
KEYWORDS="amd64 ~x86"
IUSE="libressl ssl"

RDEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl[${MULTILIB_USEDEP}] )
	)
	media-libs/libjpeg-turbo[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXv[${MULTILIB_USEDEP}]
	virtual/glu[${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
	amd64? ( abi_x86_32? (
		>=media-libs/libjpeg-turbo-1.3.0-r3[abi_x86_32]
		>=x11-libs/libX11-1.6.2[abi_x86_32]
		>=x11-libs/libXext-1.3.2[abi_x86_32]
		>=x11-libs/libXv-1.0.10[abi_x86_32]
		>=virtual/glu-9.0-r1[abi_x86_32]
		>=virtual/opengl-7.0-r1[abi_x86_32]
	) )
"
DEPEND="${RDEPEND}"

src_prepare() {
	# Use /var/lib, bug #428122
	sed -e "s#/etc/opt#/var/lib#g" -i doc/unixconfig.txt doc/index.html doc/advancedopengl.txt \
		server/vglrun.in server/vglgenkey server/vglserver_config || die

	default
}

src_configure() {
	abi_configure() {
		local mycmakeargs=(
			$(cmake-utils_use ssl VGL_USESSL)
			-DVGL_DOCDIR=/usr/share/doc/"${PF}"
			-DTJPEG_INCLUDE_DIR=/usr/include
			-DVGL_LIBDIR=/usr/$(get_libdir)
			-DTJPEG_LIBRARY=/usr/$(get_libdir)/libturbojpeg.so
			-DCMAKE_LIBRARY_PATH=/usr/$(get_libdir)
			-DVGL_FAKELIBDIR=/usr/fakelib/${ABI}
		)
		cmake-utils_src_configure
	}
	multilib_parallel_foreach_abi abi_configure
}

src_install() {
	cmake-multilib_src_install

	# Make config dir
	dodir /var/lib/VirtualGL
	fowners root:video /var/lib/VirtualGL
	fperms 0750 /var/lib/VirtualGL
	newinitd "${FILESDIR}/vgl.initd-r3" vgl
	newconfd "${FILESDIR}/vgl.confd-r2" vgl

	exeinto /usr/libexec
	doexe "${FILESDIR}/vgl-helper.sh"
	systemd_dounit "${FILESDIR}/vgl.service"

	# Rename glxinfo to vglxinfo to avoid conflict with x11-apps/mesa-progs
	mv "${D}"/usr/bin/{,v}glxinfo || die

	# Remove license files, bug 536284
	rm "${D}"/usr/share/doc/${PF}/{LGPL.txt*,LICENSE*} || die
}
