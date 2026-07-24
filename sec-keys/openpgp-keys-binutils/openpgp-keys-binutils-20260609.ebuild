# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'3A24BC1E8FB409FA9F14371813FCEF89DD9E3C4F:nickc:ubuntu'
	'5EF3A41171BB77E6110ED2D01F3D03348DB1A3E2:sam:gentoo'
)
inherit sec-keys

DESCRIPTION="OpenPGP keys used to sign GNU Binutils releases"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
