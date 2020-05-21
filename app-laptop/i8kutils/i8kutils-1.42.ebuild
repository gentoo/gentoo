# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils systemd toolchain-funcs

DESCRIPTION="Dell Inspiron and Latitude utilities"
HOMEPAGE="https://launchpad.net/i8kutils"
SRC_URI="https://launchpad.net/i8kutils/trunk/${PV}/+download/${P/-/_}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="tk"

DEPEND="tk? ( dev-lang/tk:0 )"
RDEPEND="${DEPEND}
	sys-power/acpi"

S="${WORKDIR}/${PN}"

DOCS=( README.i8kutils )

src_prepare() {
	epatch "${FILESDIR}/${PN}-gcc5.patch"
	epatch "${FILESDIR}/${P}-Makefile.patch"

	tc-export CC
}

src_install() {
	dobin i8kctl i8kfan
	doman i8kctl.1
	dodoc README.i8kutils

	newinitd "${FILESDIR}"/i8k.init-r1 i8k
	newconfd "${FILESDIR}"/i8k.conf i8k

	if use tk; then
		dobin i8kmon
		doman i8kmon.1
		dodoc i8kmon.conf
		systemd_dounit "${FILESDIR}"/i8kmon.service
	else
		cat >> "${ED}"/etc/conf.d/i8k <<- EOF

		# i8kmon disabled because the package was installed without USE=tk
		NOMON=1
		EOF
	fi
}
