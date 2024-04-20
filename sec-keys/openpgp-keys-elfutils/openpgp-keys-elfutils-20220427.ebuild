# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP key used to sign elfutils releases"
HOMEPAGE="https://sourceware.org/elfutils/"
# This is the same key as sec-keys/openpgp-keys-debugedit but it's not guaranteed
# to always be the same, so let's not assume.
SRC_URI="https://sourceware.org/elfutils/ftp/gpgkey-1AA44BE649DE760A.gpg -> ${P}-gpgkey-1AA44BE649DE760A.gpg"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - elfutils.gpg < <(cat "${files[@]/#/${DISTDIR}/}")
}
