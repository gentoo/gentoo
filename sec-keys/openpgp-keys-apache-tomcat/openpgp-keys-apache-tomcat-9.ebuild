# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'A9C5DF4D22E99998D9875A5110C01C5A2F6059E7:markt:manual'
	'DCFD35E0BF8CA7344752DE8B6FB21E8933C60243:markt2:manual'
	'48F8E69F6390C9F25CFEDCD268248959359E722B:remm:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by tomcat.apache.org"
HOMEPAGE="https://tomcat.apache.org/download-90.cgi"
SRC_URI="https://downloads.apache.org/tomcat/tomcat-$(ver_cut 1)/KEYS -> ${P}-KEYS.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="${PV}"
KEYWORDS="amd64 ~arm64"

src_install() {
	sec-keys_src_install
	mv "${ED}"/usr/share/openpgp-keys/{apache-tomcat,tomcat-${SLOT}.apache.org}.asc || die
}
