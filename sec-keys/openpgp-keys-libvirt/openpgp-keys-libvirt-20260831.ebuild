# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'453B65310595562855471199CA68BE8010084C9C:libvirt:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by libvirt"
HOMEPAGE="https://www.libvirt.org/ https://gitlab.com/libvirt/libvirt/"
SRC_URI="https://download.libvirt.org/gpg_key.asc -> ${P}-gpg_key.asc"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
