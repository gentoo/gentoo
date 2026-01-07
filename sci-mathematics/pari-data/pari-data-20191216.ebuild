# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Additional dataset packages for PARI"
HOMEPAGE="https://pari.math.u-bordeaux.fr/packages.html"

# Beware, upstream occasionally updates these tarballs in-place
# with new versions. When that happens, we need to bump this
# package to a new version so that any mirrored tarballs will
# get re-fetched to a new name.
for p in elldata galpol seadata nftables galdata; do
	SRC_URI+="https://pari.math.u-bordeaux.fr/pub/pari/packages/${p}.tgz \
		-> ${p}-${PV}.tgz "
done

S="${WORKDIR}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ~ppc ppc64 ~riscv ~sparc ~x86"

src_install() {
	insinto /usr/share/pari
	doins -r data/* nftables
}
