# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'2DB4F1EF0FA761ECC4EA935C86FDC7E2A11262CB:ggregory:ubuntu'
	'F4DD59C90148BDC52BEB90A4530AA5F25C25011F:ggregory2:ubuntu'
	'ADC51A76E03EF9BDF4635E65FC777411329D80D2:sanka:ubuntu'
	'B6E73D84EA4FCC47166087253FAAD2CD5ECBB314:chtompki:ubuntu'
	'0CC641C3A62453AB390066C4A41F13C999945293:tn:ubuntu'
	'A9C5DF4D22E99998D9875A5110C01C5A2F6059E7:markt:ubuntu'
	'A9F885A21BA0EFB7D0991E6CCAF5EC5919FEA27D:simonetripodi:ubuntu'
	'33C6E01240C5468C2B7A556954E2764B48A42DF0:kinow:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by commons.apache.org"
HOMEPAGE="https://logging.apache.org/log4j/2.x/download.html"

KEYWORDS="amd64 arm64 ppc64"

src_install() {
	sec-keys_src_install
	mv "${ED}"/usr/share/openpgp-keys/{apache-commons,commons.apache.org}.asc || die
}
