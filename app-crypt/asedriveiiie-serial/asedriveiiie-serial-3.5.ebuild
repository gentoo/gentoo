# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ASEDriveIIIe Serial Card Reader"
HOMEPAGE="https://www.athena-scs.com"
SRC_URI="http://www.athena-scs.com/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=sys-apps/pcsc-lite-1.3.0"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_install() {
	default

	local conf="/etc/reader.conf.d/${PN}.conf"

	insinto "$(dirname "${conf}")"
	newins "etc/reader.conf" "$(basename "${conf}")"
}

pkg_postinst() {
	elog "NOTICE:"
	elog "1. Update ${conf} file"
	elog "2. Run update-reader.conf, yes this is a command..."
	elog "3. Restart pcscd"
}

pkg_postrm() {
	#
	# Without this, pcscd will not start next time.
	#
	local conf="/etc/reader.conf.d/${PN}.conf"
	if ! [ -f "$(grep LIBPATH "${conf}" | sed 's/LIBPATH *//' | sed 's/ *$//g' | head -n 1)" ]; then
		rm "${conf}"
		update-reader.conf
		elog "NOTICE:"
		elog "You need to restart pcscd"
	fi
}
