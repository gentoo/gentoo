# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib-minimal

DESCRIPTION="Public client interface for NIS(YP) and NIS+ in a IPv6 ready version"
HOMEPAGE="https://github.com/thkukuk/libnsl"
SRC_URI="https://github.com/thkukuk/${PN}/archive/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1+"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND="
	!<sys-libs/glibc-2.26
	net-libs/libtirpc[${MULTILIB_USEDEP}]
"
RDEPEND=${DEPEND}

S=${WORKDIR}/${PN}-${P}

src_prepare(){
	default
	eautoreconf
}

multilib_src_configure() {
	# Fool multilib-minimal to run ./configure in out-of-tree build
	ECONF_SOURCE=${S} econf
}
