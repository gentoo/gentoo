# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Provide a faked chroot environment without requiring root privileges"
HOMEPAGE="https://github.com/dex4er/fakechroot"
SRC_URI="https://github.com/dex4er/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}/fakechroot-2.20.1-glibc-2.33.patch"
)

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f '{}' +
}
