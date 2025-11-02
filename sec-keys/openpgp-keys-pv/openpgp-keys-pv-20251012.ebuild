# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	D8FF44A79CC8A61EF694FA7EB883E01314DA8E84:pv:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Andrew Wood for sys-apps/pv"
HOMEPAGE="https://www.ivarch.com/personal/contact.shtml"
SRC_URI="https://www.ivarch.com/personal/public-key.txt -> ${P}-pv.gpg"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
