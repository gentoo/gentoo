# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GNU ARM Embedded Toolchain"
HOMEPAGE="https://developer.arm.com/open-source/gnu-toolchain/gnu-rm"
SRC_URI="https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2018q2/gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2"

LICENSE="BSD GPL-2 GPL-3 LGPL-2 LGPL-3 MIT NEWLIB ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86 -*"
RESTRICT="strip binchecks"

S="${WORKDIR}"/gcc-arm-none-eabi-7-2018-q2-update

src_install() {
	local d="/opt/${P}"
	dodir ${d}
	cp -pPR * "${D}/${d}" || die

	cat <<-EOF > "${T}/16${P}"
	PATH=${d}/bin
	ROOTPATH=${d}/bin
	LDPATH=${d}/lib
	MANPATH=${d}/share/doc/arm-arm-none-eabi/man
	EOF

	doenvd "${T}/16${P}"
}
