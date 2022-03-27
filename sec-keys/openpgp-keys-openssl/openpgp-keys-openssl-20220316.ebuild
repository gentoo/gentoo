# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by OpenSSL"
HOMEPAGE="https://www.openssl.net/"
# See https://www.openssl.org/source/ and https://www.openssl.org/community/omc.html
# Mirrored from https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x8657ABB260F056B1E5190839D9C4D26D0E604491 etc (unstable results)
SRC_URI="
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/openssl-8657ABB260F056B1E5190839D9C4D26D0E604491.asc
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/openssl-7953AC1FBC3DC8B3B292393ED5E9E43F7DF9EE8C.asc
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

S=${WORKDIR}

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - openssl.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
