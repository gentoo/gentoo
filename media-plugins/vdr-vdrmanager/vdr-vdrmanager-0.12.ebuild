# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2 ssl-cert

VERSION="1747" # every bump, new version

DESCRIPTION="VDR Plugin: allows remote programming VDR using VDR-Manager running on Android devices"
HOMEPAGE="http://projects.vdr-developer.org/projects/vdr-manager/wiki"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tar.gz"

KEYWORDS="~x86 ~amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE="gzip +ssl -stream zlib"

DEPEND=">=media-video/vdr-2
		ssl? ( dev-libs/openssl )"
RDEPEND="stream? ( media-plugins/vdr-streamdev[server] )
		zlib? ( sys-libs/zlib )"

S="${WORKDIR}/${P}"

VDR_RCADDON_FILE="${FILESDIR}/rc-addon-0.12.sh"
VDR_CONFD_FILE="${FILESDIR}/confd-0.12"

VDRMANAGER_SSL_KEY_DIR="/etc/vdr/plugins/vdrmanager"
VDRMANAGER_SSL_KEY_FILE="${VDRMANAGER_SSL_KEY_DIR}/vdrmanager"

make_vdrmanager_cert() {
	SSL_COUNTRY="${SSL_COUNTRY:-}"
	SSL_STATE="${SSL_STATE:-Unknown}"
	SSL_LOCALITY="${VDRMANAGER_SSL_LOCALITY:-Unkown}"
	SSL_ORGANIZATION="${VDRMNAGER_SSL_ORGANIZATION:-VDR-Manager Plugin}"
	SSL_UNIT="${VDRMANAGER_SSL_UNIT:-VDR Server}"
	SSL_COMMONNAME="${VDRMANAGER_SSL_COMMONNAME:-`hostname -f`}"
	SSL_EMAIL="${VDRMANAGER_SSL_EMAIL:-Unknown}"
	SSL_BITS="${VDRMANAGER_SSL_BITS:-1024}"
	SSL_DAYS="${VDRMANAGER_SSL_DAYS:-720}"

	rm -f "${ROOT}"${VDRMANAGER_SSL_KEY_FILE}.*

	install_cert ${VDRMANAGER_SSL_KEY_FILE}

	rm -f "${ROOT}"${VDRMANAGER_SSL_KEY_FILE}.{crt,csr,key}
	chown vdr:vdr "${ROOT}"${VDRMANAGER_SSL_KEY_FILE}.pem
	chmod 0400 "${ROOT}"${VDRMANAGER_SSL_KEY_FILE}.pem
}

src_prepare() {
	vdr-plugin-2_src_prepare

	BUILD_PARAMS+=" VDRMANAGER_USE_GZIP=$(usex gzip 1 0)"
	BUILD_PARAMS+=" VDRMANAGER_USE_SSL=$(usex ssl 1 0)"
	BUILD_PARAMS+=" VDRMANAGER_USE_ZLIB=$(usex zlib 1 0)"
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	einfo "Add a password to /etc/conf.d/vdr.vdrmanager"

	if use ssl ; then
		if path_exists -a "${ROOT}${VDRMANAGER_SSL_KEY_FILE}.pem"; then
			einfo "found an existing SSL cert, to create a new SSL cert, run:\n"
			einfo "emerge --config ${PN}"
		else
			einfo "No SSL cert found, creating a default one now"
			make_vdrmanager_cert
		fi
	fi
}

pkg_config() {
	make_vdrmanager_cert
}
