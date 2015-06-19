# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libltdl/libltdl-2.4.6.ebuild,v 1.11 2015/04/13 08:39:18 ago Exp $

EAPI="4"

inherit multilib-minimal

MY_P="libtool-${PV}"

DESCRIPTION="A shared library tool for developers"
HOMEPAGE="http://www.gnu.org/software/libtool/"
SRC_URI="mirror://gnu/libtool/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="static-libs"
# libltdl doesn't have a testsuite.
RESTRICT="test"

RDEPEND="!<sys-devel/libtool-2.4.3-r2:2
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140406-r2
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND="app-arch/xz-utils"

S="${WORKDIR}/${MY_P}/libltdl"

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		--enable-ltdl-install \
		$(use_enable static-libs static)
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	# While the libltdl.la file is not used directly, the m4 ltdl logic
	# keys off of its existence when searching for ltdl support. #293921
	#use static-libs || find "${D}" -name libltdl.la -delete
}
