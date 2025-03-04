# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by jakartaee-migration"
HOMEPAGE="https://tomcat.apache.org/download-native.cgi"
SRC_URI="https://downloads.apache.org/tomcat/jakartaee-migration/KEYS -> ${P}-KEYS.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm64"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - tomcat-jakartaee-migration.apache.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
