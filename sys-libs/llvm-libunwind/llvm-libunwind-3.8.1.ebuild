# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://github.com/llvm-mirror/libunwind"

MY_P="libunwind-${PV}"
SRC_URI="http://llvm.org/releases/${PV}/${MY_P}.src.tar.xz"
S="${WORKDIR}/${MY_P}.src"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+static-libs"

DEPEND=""
RDEPEND="!sys-libs/libunwind"

src_prepare() {
	default
	cp "${FILESDIR}/Makefile" src/ || die
}

src_compile() {
	emake -C src shared
	use static-libs && emake -C src static
}

src_install() {
	dolib.so src/libunwind.so*
	use static-libs && dolib.a src/libunwind.a
}
