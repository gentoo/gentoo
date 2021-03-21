# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Ralf Hoffmann's openPGP key used to sign app-misc/worker releases"
HOMEPAGE="http://www.boomerangsworld.de/cms/about.html"
SRC_URI="
	https://keys.openpgp.org/vks/v1/by-fingerprint/F9299EE90A729029E71AF26B667132D0FBC52B37
		-> RalfHoffmann.asc
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"

S=${WORKDIR}

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - RalfHoffmann.asc < <(cat "${files[@]/#/${DISTDIR}/}")
}
