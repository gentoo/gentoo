# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit verify-sig

DESCRIPTION="A collection of profiles for the AppArmor application security system"
HOMEPAGE="https://gitlab.com/apparmor/apparmor/wikis/home"
SRC_URI="
	https://gitlab.com/apparmor/apparmor/-/archive/v${PV}/apparmor-v${PV}.tar.bz2 -> ${P}.tar.bz2
	verify-sig? ( https://gitlab.com/api/v4/projects/4484878/packages/generic/signatures/${PV}/apparmor-v${PV}.tar.bz2.asc
		-> ${P}.tar.bz2.asc )
"

S=${WORKDIR}/apparmor-v${PV}/profiles

LICENSE="GPL-2"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE="minimal verify-sig"
RESTRICT="test"
BDEPEND="
	verify-sig? ( sec-keys/openpgp-keys-apparmor )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/apparmor.asc

src_install() {
	if use minimal ; then
		insinto /etc/apparmor.d
		doins -r apparmor.d/{abi,abstractions,tunables}
	else
		default
	fi
}
