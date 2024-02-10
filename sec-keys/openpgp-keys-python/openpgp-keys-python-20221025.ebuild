# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used to sign CPython releases"
HOMEPAGE="https://www.python.org/downloads/"
SRC_URI="
	https://keybase.io/pablogsal/pgp_keys.asc?fingerprint=a035c8c19219ba821ecea86b64e628f8d684696d
		-> a035c8c19219ba821ecea86b64e628f8d684696d.asc
	https://keybase.io/ambv/pgp_keys.asc?fingerprint=e3ff2839c048b25c084debe9b26995e310250568
		-> e3ff2839c048b25c084debe9b26995e310250568-r1.asc
	https://keybase.io/nad/pgp_keys.asc?fingerprint=0d96df4d4110e5c43fbfb17f2d347ea6aa65421d
		-> 0d96df4d4110e5c43fbfb17f2d347ea6aa65421d.asc
	https://keybase.io/nad/pgp_keys.asc?fingerprint=c9b104b3dd3aa72d7ccb1066fb9921286f5e1540
		-> c9b104b3dd3aa72d7ccb1066fb9921286f5e1540.asc
	https://keybase.io/bp/pgp_keys.asc?fingerprint=c01e1cad5ea2c4f0b8e3571504c367c218add4ff
		-> c01e1cad5ea2c4f0b8e3571504c367c218add4ff.asc
	https://github.com/Yhg1s.gpg
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

S=${WORKDIR}

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - python.org.asc < <(cat "${files[@]/#/${DISTDIR}/}")
}
