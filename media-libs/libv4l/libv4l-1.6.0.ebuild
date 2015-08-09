# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils linux-info udev multilib-minimal

MY_P=v4l-utils-${PV}

DESCRIPTION="Separate libraries ebuild from upstream v4l-utils package"
HOMEPAGE="http://git.linuxtv.org/v4l-utils.git"
SRC_URI="http://linuxtv.org/downloads/v4l-utils/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

# The libraries only link to -ljpeg, therefore multilib depend only for virtual/jpeg.
RDEPEND=">=virtual/jpeg-0-r2:0=[${MULTILIB_USEDEP}]
	virtual/glu
	virtual/opengl
	x11-libs/libX11:=
	!media-tv/v4l2-ctl
	!<media-tv/ivtv-utils-1.4.0-r2
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-medialibs-20130224-r5
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)]
	)"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/os-headers
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	CONFIG_CHECK="~SHMEM"
	linux-info_pkg_setup
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		--disable-static \
		--disable-qv4l2 \
		--disable-v4l-utils \
		--with-udevdir="$(get_udevdir)"
}

multilib_src_compile() {
	emake -C lib
}

multilib_src_install() {
	emake -j1 -C lib DESTDIR="${D}" install
}

multilib_src_install_all() {
	dodoc ChangeLog README.lib* TODO
	prune_libtool_files --all
}
