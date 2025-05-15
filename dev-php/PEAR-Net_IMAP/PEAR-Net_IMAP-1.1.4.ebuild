# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Provides an implementation of the IMAP protocol"
HOMEPAGE="https://pear.php.net/package/Net_IMAP
	https://github.com/pear/Net_IMAP"
SRC_URI="https://pear.php.net/get/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc64 sparc x86"
IUSE="sasl"
RDEPEND="dev-lang/php:*
	dev-php/PEAR-Net_Socket
	dev-php/PEAR-PEAR
	sasl? ( dev-php/PEAR-Auth_SASL )"

src_install() {
	insinto /usr/share/php
	doins -r Net
	dodoc docs/*
	insinto /usr/share/php/.packagexml
	newins "${WORKDIR}/package.xml" "${MY_P}.xml"
}

pkg_postinst() {
	# It is not critical to complete so only warn on failure
	if [[ -f "${EROOT}/usr/share/php/.packagexml/${MY_P}.xml" && \
		-x "${EROOT}/usr/bin/peardev" ]] ; then
		"${EROOT}/usr/bin/peardev" install -nrO --force \
			"${EROOT}/usr/share/php/.packagexml/${MY_P}.xml" 2> /dev/null \
			|| ewarn "Failed to insert package into local PEAR database"
	fi
}

pkg_postrm() {
	if [[ -x "${EROOT}/usr/bin/peardev" ]]; then
		"${EROOT}/usr/bin/peardev" uninstall -nrO "pear.php.net/${MY_PN}"
	fi
}
