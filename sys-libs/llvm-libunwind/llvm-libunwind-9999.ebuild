# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://github.com/llvm-mirror/libunwind"
if [ "${PV%9999}" = "${PV}" ] ; then
	KEYWORDS="~amd64"
	SRC_URI="http://llvm.org/releases/${PV}/libunwind-${PV}.src.tar.xz"
else
	KEYWORDS=""
	SRC_URI=""
fi

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
IUSE="+static-libs"

DEPEND=""
RDEPEND="!sys-libs/libunwind"

src_unpack() {
	default
	S="${WORKDIR}/libunwind-${PV}.src"
}

src_prepare() {
	cp "${FILESDIR}/Makefile" src/ || die
}

src_compile() {
	cd src || die
	emake shared
	use static-libs && emake static
}

src_install() {
	dolib.so src/libunwind.so*
	use static-libs && dolib.a src/libunwind.a
}
