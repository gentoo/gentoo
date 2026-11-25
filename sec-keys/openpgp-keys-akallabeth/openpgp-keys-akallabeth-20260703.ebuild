# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'7703B333420E0AEF995EB4B3A49454A3FC909FD5:akallabeth:github,ubuntu'
	'96487F87AB317D3C9B58531D2CF4A2D2D3D72105:akallabeth:github'
)

inherit sec-keys

DESCRIPTION="OpenPGP key for Github user akallabeth"
HOMEPAGE="https://github.com/akallabeth"

KEYWORDS="~alpha amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"
