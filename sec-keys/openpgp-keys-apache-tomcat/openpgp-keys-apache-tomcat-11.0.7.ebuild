# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by tomcat.apache.org"
HOMEPAGE="https://tomcat.apache.org/download-11.cgi"
SRC_URI="https://downloads.apache.org/tomcat/tomcat-$(ver_cut 1)/v${PV}/KEYS -> ${P}-KEYS.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="${PV}"
KEYWORDS="amd64 ~arm64"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - tomcat-${PV}.apache.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
