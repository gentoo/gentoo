# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by libvirt"
HOMEPAGE="https://www.libvirt.org/ https://gitlab.com/libvirt/libvirt/"
SRC_URI="https://libvirt.org/sources/gpg_key.asc -> 453B65310595562855471199CA68BE8010084C9C.asc"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

S=${WORKDIR}

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - libvirt.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
