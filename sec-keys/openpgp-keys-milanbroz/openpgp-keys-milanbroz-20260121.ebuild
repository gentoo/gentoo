# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	# 2.17 How do I Verify I have an Authentic cryptsetup Source Package?
	# https://gitlab.com/cryptsetup/cryptsetup/-/wikis/FrequentlyAskedQuestions#2-setup
	2A2918243FDE46648D0686F9D9B0577BD93E98FC:mbroz:github
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Milan Broz"
HOMEPAGE="https://github.com/mbroz"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
