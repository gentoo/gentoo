# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Upstream seem to be kind of dead, so using Debian's patches.
DESCRIPTION="Provide a faked chroot environment without requiring root privileges"
HOMEPAGE="https://github.com/dex4er/fakechroot"
if [[ ${PV} == *_p* ]] ; then
	inherit autotools

	SRC_URI="mirror://debian/pool/main/f/${PN}/${PN}_$(ver_cut 1-3)+ds.orig.tar.xz"
	SRC_URI+=" mirror://debian/pool/main/f/${PN}/${PN}_$(ver_cut 1-3)+ds-$(ver_cut 5).debian.tar.xz"
	S="${WORKDIR}"/${PN}-$(ver_cut 1-3)
else
	SRC_URI="https://github.com/dex4er/${PN}/releases/download/${PV}/${P}.tar.gz"
fi

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RESTRICT="test"

src_prepare() {
	default

	if [[ ${PV} == *_p* ]] ; then
		if [[ -d "${WORKDIR}"/debian/patches ]] ; then
			eapply $(sed -e 's:^:../debian/patches/:' ../debian/patches/series || die)
		fi

		eautoreconf
	fi
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
