# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'44F4797A52C336FA666CD9271DE461528F1F1B2A:reschke:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by https://jackrabbit.apache.org"
HOMEPAGE="https://jackrabbit.apache.org/jcr/downloads.html"

LICENSE="public-domain"
KEYWORDS="amd64 ppc64"

src_install() {
	sec-keys_src_install
	mv "${ED}"/usr/share/openpgp-keys/{apache-jackrabbit,jackrabbit-apache.org}.asc || die
}
