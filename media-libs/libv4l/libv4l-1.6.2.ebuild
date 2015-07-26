# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libv4l/libv4l-1.6.2.ebuild,v 1.8 2015/07/23 20:24:50 pacho Exp $

EAPI=5
inherit eutils linux-info multilib-minimal

MY_P=v4l-utils-${PV}

DESCRIPTION="Separate libraries ebuild from upstream v4l-utils package"
HOMEPAGE="http://git.linuxtv.org/v4l-utils.git"
SRC_URI="http://linuxtv.org/downloads/v4l-utils/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="jpeg"

# The libraries only link to -ljpeg, therefore multilib depend only for virtual/jpeg.
RDEPEND="jpeg? ( >=virtual/jpeg-0-r2:0=[${MULTILIB_USEDEP}] )
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
	# Hard disable the flags that apply only to the utils.
	ECONF_SOURCE=${S} \
	econf \
		--disable-static \
		--disable-qv4l2 \
		--disable-v4l-utils \
		--without-libudev \
		$(use_with jpeg)
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
