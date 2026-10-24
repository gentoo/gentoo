# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

# We need a stable list, so even though the offical site specifically
# says not to pull it from VCS because it may break, the only other option
# is to store snapshots of the list somewhere and pull that

COMMIT="f540a06159213b6e8ed9c87d2dd3a52373637e92"

DESCRIPTION="The Public Suffix List"
HOMEPAGE="https://publicsuffix.org"
SRC_URI="https://github.com/publicsuffix/list/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/list-${COMMIT}"

LICENSE="MPL-2.0"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

# Can't run the tests without libpsl, and its useless to us anyway
RESTRICT="test"

# Portage does not empty functions, so fake it
src_compile() {
	# Skip the Makefile
	true
}

src_install() {
	insinto /usr/share/publicsuffix
	doins public_suffix_list.dat
}
