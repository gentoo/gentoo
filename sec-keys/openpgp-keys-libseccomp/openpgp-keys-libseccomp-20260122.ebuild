# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	7100AADFAE6E6E940D2E0AD655E45A5AE8CA7C8A:pcmoore:github
	47A68FCE37C7D7024FD65E11356CE62C2B524099:drakenclimber:github
)

inherit sec-keys

DESCRIPTION="OpenPGP key used for sys-libs/libseccomp"
HOMEPAGE="https://github.com/seccomp/libseccomp#verifying-release-tarballs"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
