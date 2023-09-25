# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used to sign Apache Xalan-C"
HOMEPAGE="https://xalan.apache.org/"
SRC_URI="https://downloads.apache.org/xalan/xalan-c/KEYS -> ${P}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

S="${WORKDIR}"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - apache-xalan-c.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
