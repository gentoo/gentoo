# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils linux-info multilib toolchain-funcs

MY_P=v4l-utils-${PV}

DESCRIPTION="Separate libraries ebuild from upstream v4l-utils package"
HOMEPAGE="http://git.linuxtv.org/v4l-utils.git"
SRC_URI="http://linuxtv.org/downloads/v4l-utils/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="virtual/jpeg"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.30-r1"

S=${WORKDIR}/${MY_P}

CONFIG_CHECK="~SHMEM"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.8.8-drop-Wp-flags.patch
	sed -i \
		-e "/^PREFIX =/s:=.*:= ${EPREFIX}/usr:" \
		-e "/^LIBDIR =/s:/lib:/$(get_libdir):" \
		-e "/^CFLAGS :=/d" \
		Make.rules || die
	tc-export CC
}

src_compile() {
	emake -C lib
}

src_install() {
	emake -C lib DESTDIR="${D}" install
	dodoc ChangeLog README.lib* TODO
}
