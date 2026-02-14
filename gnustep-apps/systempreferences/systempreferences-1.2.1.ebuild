# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-2 verify-sig

MY_P="SystemPreferences-${PV}"

DESCRIPTION="System Preferences is a clone of Apple OS X' System Preferences"
HOMEPAGE="https://github.com/gnustep/apps-systempreferences"
SRC_URI="
	https://github.com/gnustep/apps-systempreferences/releases/download/systempreferences-${PV//./_}/${MY_P}.tar.gz
	verify-sig? ( https://github.com/gnustep/apps-systempreferences/releases/download/systempreferences-${PV//./_}/${MY_P}.tar.gz.sig )
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	gnustep-base/gnustep-base:=
	gnustep-base/gnustep-gui
"
DEPEND="${RDEPEND}"
BDEPEND="
	verify-sig? ( sec-keys/openpgp-keys-gnustep )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gnustep.asc
