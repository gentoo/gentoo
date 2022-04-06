# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP key used to sign bzip2 releases"
HOMEPAGE="https://www.sourceware.org/bzip2/downloads.html"
# This is the same key as sec-keys/openpgp-keys-debugedit but it's not guaranteed
# to always be the same, so let's not assume.
SRC_URI="https://www.sourceware.org/pub/bzip2/gpgkey-5C1D1AA44BE649DE760A.gpg -> ${P}-gpgkey-5C1D1AA44BE649DE760A.gpg"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - bzip2.gpg < <(cat "${files[@]/#/${DISTDIR}/}")
}
