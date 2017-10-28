# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="The Sandbox escapist tool"
HOMEPAGE="https://dev.gentoo.org/~mgorny/dist/unsandbox.c"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/unsandbox.c"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}"/unsandbox.c "${WORKDIR}"/ || die
}

src_compile() {
	tc-export CC
	emake LDLIBS=-ldl unsandbox
}

src_install() {
	dobin unsandbox
}
