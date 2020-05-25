# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="ethersrv-linux"
MY_PV_TSR="0.8.2"
MY_P="${MY_PN}-${PV}"

inherit systemd toolchain-funcs

DESCRIPTION="An ethernet-based file system for DOS"
HOMEPAGE="http://etherdfs.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${MY_P}.tar.xz
	tsr? ( mirror://sourceforge/${PN}/v${MY_PV_TSR}/${PN}.zip -> ${P}.zip )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tsr"

BDEPEND="tsr? ( app-arch/unzip )"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/${P}-makefile.patch" )

DOCS=( "ethersrv-linux.txt" "history.txt" )

src_prepare() {
	default

	# Respect users LDFLAGS
	sed -e 's/$(CFLAGS)/& $(LDFLAGS)/' -i Makefile || die
}

src_compile() {
	tc-export CC

	default
}

src_install() {
	dobin ethersrv-linux

	if use tsr; then
		insinto /usr/share/etherdfs
		newins ../ETHERDFS.EXE etherdfs.exe

		DOCS+=( "../ETHERDFS.TXT" "../HISTORY.TXT" )
	fi

	newinitd "${FILESDIR}"/etherdfs.initd etherdfs
	newconfd "${FILESDIR}"/etherdfs.confd etherdfs
	systemd_dounit "${FILESDIR}"/etherdfs.service

	einstalldocs
}
