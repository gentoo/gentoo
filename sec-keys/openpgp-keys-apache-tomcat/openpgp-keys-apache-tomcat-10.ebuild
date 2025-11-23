# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'A9C5DF4D22E99998D9875A5110C01C5A2F6059E7:markt:manual'
	'5C3C5F3E314C866292F359A8F3AD5C94A67F707E:schultz:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by tomcat.apache.org"
HOMEPAGE="https://tomcat.apache.org/download-10.cgi"
SRC_URI="https://downloads.apache.org/tomcat/tomcat-$(ver_cut 1)/KEYS -> ${P}-KEYS.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="${PV}"
KEYWORDS="amd64 ~arm64"

src_install() {
	sec-keys_src_install
	mv "${ED}"/usr/share/openpgp-keys/{apache-tomcat-${SLOT},tomcat-${SLOT}.apache.org}.asc || die
}
