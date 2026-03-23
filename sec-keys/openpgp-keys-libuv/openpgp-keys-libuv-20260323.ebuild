# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See the following:
# - https://github.com/libuv/libuv/blob/v1.x/MAINTAINERS.md
# - https://github.com/libuv/libuv/issues/4306
# - https://github.com/libuv/libuv/issues/4307
#
# Most keys are uploaded to keyserver.ubuntu.com, some are not.
#
# Some keys at keyserver.ubuntu.com are not "registered", so no UID.
#
# Some keys are uploaded to github.com, some are not.
#
# Some keys at github.com are expired, despite owner having extended
# them locally and still using them.
#
# GitHub key export (/username.gpg) may include cruft comment lines
# which cause GPG to error during import.
#
# Most keys are stored within the git repo, but in a manner that cannot
# be fetched via https://github.com/, only by cloning the repo.
#
# Some of the keys stored in the repo are expired
SEC_KEYS_VALIDPGPKEYS=(
	'D77B1E34243FBAF05F8E9CC34F55C8C846AB89B9:bnoordhuis:ubuntu'
	# GH comment breaks this
	'94AE36675C464D64BAFA68DD7434390BDBE9B9C5:cjihrig:openpgp'
	#'57353E0DBDAAA7E839B66A1AFF47D5E4AD8B4FDC:cjihrig-kb:ubuntu'
	# GH comment breaks this
	'AEAD0A4B686767751A0E4AEF34A25FB128246514:vtjnash:ubuntu'
	'CFBB9CA9A5BEAFD70E2B3C5A79A67C55A3679C8B:vtjnash-2022:ubuntu'
	'5804F9998A922AFBA39847A0718350906134887F:erw7:github'
	'C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C:richardlau:github'
	'612F0EAD9401622379DF4402F28C3C8DA33C03BE:santigimeno:github,ubuntu'
	'FDF519364458319FA8233DC9410E5553AE9BC059:saghul:openpgp'
	# GH comment breaks this
	#'AEFC279A0C9306767E5829A1251CA676820DC7F3:trevnorris:github'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by libuv"
HOMEPAGE="https://libuv.org/"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
