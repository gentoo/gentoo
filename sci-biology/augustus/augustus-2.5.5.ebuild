# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Eukaryotic gene predictor"
HOMEPAGE="http://augustus.gobics.de/"
SRC_URI="http://augustus.gobics.de/binaries/${PN}.${PV}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

S="${WORKDIR}/${PN}.${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-sane-build.patch
	tc-export CC CXX
}

src_compile() {
	emake clean && emake
}

src_install() {
	dobin bin/*
#	dobin src/{augustus,etraining,consensusFinder,curve2hints,fastBlockSearch,prepareAlign}

	exeinto /usr/libexec/${PN}
	doexe scripts/*.p*
	insinto /usr/libexec/${PN}
	doins scripts/*.conf

	insinto /usr/share/${PN}
	doins -r config

	echo "AUGUSTUS_CONFIG_PATH=\"/usr/share/${PN}/config\"" > "${S}/99${PN}"
	doenvd "${S}/99${PN}"

	dodoc -r README.TXT HISTORY.TXT docs/*.{pdf,txt}

	if use examples; then
		insinto /usr/share/${PN}/
		doins -r docs/tutorial examples
	fi
}
