# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs flag-o-matic eutils

DESCRIPTION="Utility to change hard drive performance parameters"
HOMEPAGE="https://sourceforge.net/projects/hdparm/"
SRC_URI="mirror://sourceforge/hdparm/${P}.tar.gz"

LICENSE="BSD GPL-2" # GPL-2 only
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="static"

PATCHES=(
	"${FILESDIR}"/${PN}-9.48-sysmacros.patch #580052
	"${FILESDIR}"/${PN}-9.51-build.patch
)

src_prepare() {
	epatch "${PATCHES[@]}"
	use static && append-ldflags -static
}

src_configure() {
	tc-export CC
	export STRIP=:
}

src_install() {
	into /
	dosbin hdparm contrib/idectl

	newinitd "${FILESDIR}"/hdparm-init-8 hdparm
	newconfd "${FILESDIR}"/hdparm-conf.d.3 hdparm

	doman hdparm.8
	dodoc hdparm.lsm Changelog README.acoustic hdparm-sysconfig
	docinto wiper
	dodoc wiper/{README.txt,wiper.sh}
	docompress -x /usr/share/doc/${PF}/wiper/wiper.sh
}
