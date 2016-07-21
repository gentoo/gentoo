# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-multilib

# svn export http://svn.musepack.net/libreplaygain libreplaygain-${PV}
# tar -cJf libreplaygain-${PV}.tar.xz libreplaygain-${PV}

DESCRIPTION="Replay Gain library from Musepack"
HOMEPAGE="http://www.musepack.net/"
SRC_URI="https://dev.gentoo.org/~ssuominen/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""
RDEPEND="abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20130224-r2
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"

src_prepare() {
	sed -i -e '/CMAKE_C_FLAGS/d' CMakeLists.txt || die
}

src_install() {
	cmake-multilib_src_install
	insinto /usr/include
	doins -r include/replaygain
}
