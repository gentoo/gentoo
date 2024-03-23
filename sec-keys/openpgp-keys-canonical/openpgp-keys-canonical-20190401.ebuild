# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="OpenPGP keys used to sign LXD-related packages"
HOMEPAGE="https://ubuntu.com/lxd"
SRC_URI="https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xed1ca1e7a6f80e22e5cb2da84ace106615754614 -> 15754614.asc"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

S="${WORKDIR}"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - canonical.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
