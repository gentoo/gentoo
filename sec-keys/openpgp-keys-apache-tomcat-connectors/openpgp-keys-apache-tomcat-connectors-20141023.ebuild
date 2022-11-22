# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by commons.apache.org"
HOMEPAGE="https://tomcat.apache.org/download-native.cgi"
SRC_URI="https://downloads.apache.org/tomcat/tomcat-connectors/KEYS -> ${P}-KEYS.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - tomcat-connectors.apache.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
