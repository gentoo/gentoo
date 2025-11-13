# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'077E8893A6DCC33DD4A4D5B256E73BA9A0B592D0:private:ubuntu'
	'53C935821AA6A755BD337DB53595395EB3D8E1BA:rgoers:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by logging.apache.org"
HOMEPAGE="https://logging.apache.org/log4j/2.x/download.html"

KEYWORDS="amd64 arm64 ppc64"

src_install() {
	sec-keys_src_install
	mv "${ED}"/usr/share/openpgp-keys/{apache-logging,logging.apache.org}.asc || die
}
