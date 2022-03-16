# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by processone/ejabberd"
HOMEPAGE="https://www.process-one.net/"
# See https://www.process-one.net/blog/verifying_process_one_downloads_integrity/
SRC_URI="
	https://www.process-one.net/downloads/KEYS
		-> processone-31468D18DF9841242B90D7328ECA469419C09311.asc
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

S=${WORKDIR}

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - process-one.net.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
