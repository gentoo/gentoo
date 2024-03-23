# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP key used to sign elfutils releases"
HOMEPAGE="https://sourceware.org/elfutils/"
# This is the same key as sec-keys/openpgp-keys-debugedit but it's not guaranteed
# to always be the same, so let's not assume.
#SRC_URI="https://sourceware.org/elfutils/ftp/gpgkey-1AA44BE649DE760A.gpg -> ${P}-gpgkey-1AA44BE649DE760A.gpg"
SRC_URI="https://sourceware.org/git/?p=elfutils.git;a=blob_plain;f=GPG-KEY;h=dca558b76ca1eeb22d52b1993510c54d0d8ad75f;hb=ec5ce487c15dcd709d033dd5693b468ac34223ce -> ${P}.gpg"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - elfutils.gpg < <(cat "${files[@]/#/${DISTDIR}/}")
}
