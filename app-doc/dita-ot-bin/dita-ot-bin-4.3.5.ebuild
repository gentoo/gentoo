# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

MY_PN=${PN%*-bin}
MY_P=${MY_PN}-${PV}
DESCRIPTION="Darwin Information Typing Architecture - Open Toolkit publishing engine"
HOMEPAGE="https://www.dita-ot.org/ https://github.com/dita-ot/dita-ot"
SRC_URI="https://github.com/dita-ot/dita-ot/releases/download/${PV}/${MY_P}.zip"
S="${WORKDIR}"/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-17:*"
RDEPEND=">=virtual/jre-17:*"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${PN}-4.3-set-java-home.patch
)

src_prepare() {
	default
	java-pkg-2_src_prepare
}

src_install() {
	local installpath=/opt/${MY_P}
	local installbinpath="${installpath}"/bin
	insinto "${installpath}"
	doins -r config lib plugins resources

	java-pkg_regjar "${installpath}"/lib/dost.jar

	exeinto "${installbinpath}"
	doexe bin/dita
	dosym -r "${installbinpath}"/dita /usr/bin/dita

	einstalldocs
}
