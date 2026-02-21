# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/ludovicrousseau.asc
inherit perl-module verify-sig

MY_PN=Chipcard-PCSC
DESCRIPTION="A Perl Module for PC/SC SmartCard access"
HOMEPAGE="https://pcsc-perl.apdu.fr/"
SRC_URI="
	https://pcsc-perl.apdu.fr/${MY_PN}-v${PV}.tar.gz
	verify-sig? ( https://pcsc-perl.apdu.fr/${MY_PN}-v${PV}.tar.gz.asc )
"
S="${WORKDIR}"/${MY_PN}-v${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ppc ppc64 ~sparc x86"

RESTRICT="test" # actually accesses the pcsc-lite daemon

DEPEND=">=sys-apps/pcsc-lite-1.6.0"
RDEPEND="${DEPEND}"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-ludovicrousseau )"
