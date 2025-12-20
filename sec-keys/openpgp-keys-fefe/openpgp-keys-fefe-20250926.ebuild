# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used to sign packages from http://www.fefe.de/"
HOMEPAGE="http://www.fefe.de/"
SRC_URI="http://www.fefe.de/felix@fefe.de.asc"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~sparc ~x86"

S=${WORKDIR}

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - fefe.asc < <(cat "${files[@]/#/${DISTDIR}/}")
}
