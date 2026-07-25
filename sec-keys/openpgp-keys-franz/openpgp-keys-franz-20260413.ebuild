# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	"FCE8B369F2F0B73FD546DAAC0375688EE44CD168:franz:github"
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Michal Babej (franz)"
HOMEPAGE="https://github.com/franz"

KEYWORDS="~amd64 ~ppc64"
