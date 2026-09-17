# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	5458C3100671F252B0F4C7708079D18C21AAAAFF:astiob:github
	5EE63F2A71BF132CFE3567E1DFFE615F2824C720:theoneric:github
	E0D5E95A944CF3AAF8FC1CFBE674C942077767EB:rcombs:github
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used to sign libass releases"
HOMEPAGE="https://github.com/libass/libass/blob/master/MAINTAINERS"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
