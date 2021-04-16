# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Delta-Update - patch system for updating source-archives."
HOMEPAGE="http://deltup.sourceforge.net"
SRC_URI="https://github.com/jjwhitney/Deltup/archive/v${PV}.tar.gz -> ${P}.tar.gz"

MY_PN="Deltup"
S="${WORKDIR}/${MY_PN}-${PV}/src"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="libressl"

DEPEND="
	sys-libs/zlib
	app-arch/bzip2
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
"
RDEPEND="${DEPEND}
	|| ( dev-util/bdelta =dev-util/xdelta-1* )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.6-ldflags.patch
	"${FILESDIR}"/${PN}-0.4.6-cxx.patch
)

src_compile() {
	emake CXX=$(tc-getCXX)
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
	dodoc "${S}"/../{README,ChangeLog}
	doman "${S}"/../deltup.1
}
