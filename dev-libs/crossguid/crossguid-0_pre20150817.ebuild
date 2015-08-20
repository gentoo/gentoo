# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/graeme-hill/crossguid.git"
	inherit git-r3
else
	EGIT_COMMIT="8f399e8bd4252be9952f3dfa8199924cc8487ca4"
	SRC_URI="https://github.com/graeme-hill/crossguid/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
fi

DESCRIPTION="Lightweight cross platform C++ GUID/UUID library"
HOMEPAGE="https://github.com/graeme-hill/crossguid"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# We use libuuid from util-linux.
DEPEND="sys-apps/util-linux"
RDEPEND="${DEPEND}"

e() { echo "$@"; "$@"; }

src_compile() {
	e $(tc-getCXX) \
		${CXXFLAGS} ${CPPFLAGS} ${LDFLAGS} \
		-std=c++11 \
		-c guid.cpp -o guid.o \
		-DGUID_LIBUUID \
		|| die

	e $(tc-getAR) rs libcrossguid.a guid.o || die
}

src_install() {
	insinto /usr/include
	doins guid.h
	dolib.a libcrossguid.a
}
