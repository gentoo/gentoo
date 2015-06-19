# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dtc/dtc-1.4.0.ebuild,v 1.3 2014/06/04 16:04:58 ago Exp $

EAPI="4"
MY_P="${PN}-v${PV}"

inherit multilib toolchain-funcs
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.jdl.com/software/dtc.git"
	inherit git-2
else
	SRC_URI="http://www.jdl.com/software/${MY_P}.tar.xz"
	KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
fi

DESCRIPTION="Open Firmware device-trees compiler"
HOMEPAGE="http://git.jdl.com/gitweb/?p=dtc.git"

LICENSE="GPL-2"
SLOT="0"
IUSE="static-libs"

RDEPEND=""
DEPEND="app-arch/xz-utils
	sys-devel/flex
	sys-devel/bison"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i \
		-e '/^CFLAGS =/s:=:+=:' \
		-e '/^CPPFLAGS =/s:=:+=:' \
		-e 's:-Werror::' \
		-e 's:-g -Os::' \
		-e '/^PREFIX =/s:=.*:= /usr:' \
		-e "/^LIBDIR =/s:=.*:= \$(PREFIX)/$(get_libdir):" \
		Makefile || die
	tc-export AR CC
	export V=1
}

src_test() {
	emake check
}

src_install() {
	emake DESTDIR="${D}" install
	use static-libs || find "${ED}" -name '*.a' -delete
	dodoc Documentation/manual.txt
}
