# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by tomcat-connectors"
HOMEPAGE="https://tomcat.apache.org/download-native.cgi"
SRC_URI="https://downloads.apache.org/tomcat/tomcat-connectors/KEYS -> ${P}-KEYS.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ia64 ~ppc ppc64 ~sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - tomcat-connectors.apache.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
