# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'0A123C1ED3F13A6A0140E166C71FB765CD9DE313:ant-1.10.15:ubuntu'
	'9C60C6B3A5A9DF8FEDD299D65BE0BA8CB80602AE:ant-ivy-2.5.3:ubuntu'
	'BC26C53AF531F8B4B3F5930AAFBD3AF8EAFA72DA:ant-1.10.17:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by ant.apache.org"
HOMEPAGE="https://ant.apache.org/srcdownload.cgi"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

src_install() {
	sec-keys_src_install
	mv "${ED}"/usr/share/openpgp-keys/{apache-ant,ant.apache.org}.asc || die
}
