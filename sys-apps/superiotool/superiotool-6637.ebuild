# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

if [[ ${PV} == *99999999 ]] ; then
	ESVN_REPO_URI="svn://coreboot.org/coreboot/trunk/util/${PN}"
	inherit subversion
else
	SRC_URI="mirror://gentoo/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="util to detect Super I/O chips and functionality"
HOMEPAGE="https://www.coreboot.org/Superiotool"

LICENSE="GPL-2"
SLOT="0"
IUSE="pci"

RDEPEND="pci? ( sys-apps/pciutils )"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

src_prepare() {
	default

	sed -i \
		-e 's:-Werror ::' \
		-e 's:-O2 ::' \
		-e 's:\s\+\?-lz\s\+\?::' \
		-e "/^CONFIG_PCI =/s:=.*:=$(usex pci yes no):" \
		-e '/PREFIX/s:=.*:= /usr:' \
		Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		SVNDEF="-D'SUPERIOTOOL_VERSION=\"${ESVN_WC_REVISION}\"'"
}
