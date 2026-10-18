# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Small and lightweight parser library for ATA S.M.A.R.T. hard disks"
HOMEPAGE="https://salsa.debian.org/utopia-team/libatasmart"
SRC_URI="
	mirror://debian/pool/main/liba/${PN}/${PN}_${PV/_p*}.orig.tar.xz
	mirror://debian/pool/main/liba/${PN}/${PN}_${PV/_p/-}.debian.tar.xz
"
S="${WORKDIR}/${P/_p*}"

LICENSE="LGPL-2.1+"
SLOT="0/4"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="virtual/libudev:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	# bug #470874
	PATCHES=(
		$(sed -e 's:^:../debian/patches/:' "${WORKDIR}"/debian/patches/series || die)

		"${FILESDIR}"/${PN}-0.19_p5_do-not-fortify-source.patch
	)

	default
	eautoreconf
}

src_compile() {
	tc-export_build_env
	emake
}

src_install() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
}
