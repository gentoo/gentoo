# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The fingerprint is also listed in release announcements like
# https://lore.kernel.org/alsa-devel/b60207fd-e214-4d8c-8a56-9d2b1f3509ff@perex.cz/T/#u
SEC_KEYS_VALIDPGPKEYS=(
	'F04DF50737AC1A884C4B3D718380596DA6E59C91:alsa:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by the Alsa Project"
HOMEPAGE="https://www.alsa-project.org/files/pub/"
SRC_URI="https://www.alsa-project.org/files/pub/gpg-release-key-v1.txt -> ${P}.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
