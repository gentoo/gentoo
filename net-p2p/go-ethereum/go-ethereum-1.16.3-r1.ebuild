# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-env go-module systemd

LONG_VERSION="${PV}+build2333+plucky"
DESCRIPTION="Official golang implementation of the Ethereum protocol"
HOMEPAGE="https://github.com/ethereum/go-ethereum"
SRC_URI="https://ppa.launchpadcontent.net/ethereum/ethereum/ubuntu/pool/main/e/ethereum/ethereum_${LONG_VERSION}.tar.xz -> ${P}.tar.xz"
# Above PPA is listed as an official source here:
# https://geth.ethereum.org/docs/getting-started/installing-geth#ubuntu-via-ppas
S="${WORKDIR}/ethereum-${LONG_VERSION}"

LICENSE="GPL-3+ LGPL-3+ MIT || ( BSD GPL-2 ) BSD-2 LGPL-2.1+ Apache-2.0 ISC MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="devtools"

RDEPEND="
	acct-group/geth
	acct-user/geth
"

# Does all kinds of wonky stuff like connecting to Docker daemon, network activity, ...
RESTRICT+=" test"

src_unpack() {
	default
	mv "${S}/.mod" "${WORKDIR}/go-mod" || die
}

src_compile() {
	go-env_set_compile_environment
	emake $(usex devtools all geth)
}

src_install() {
	einstalldocs

	dobin build/bin/geth

	systemd_dounit "${FILESDIR}/${PN}@.service"
	systemd_install_dropin "${PN}@.service" "${FILESDIR}/${PN}@.service.conf"

	# TODO: replace with wildcard
	if use devtools; then
		dobin build/bin/abidump
		dobin build/bin/abigen
		dobin build/bin/blsync
		dobin build/bin/clef
		dobin build/bin/devp2p
		dobin build/bin/era
		dobin build/bin/ethkey
		dobin build/bin/evm
		dobin build/bin/rlpdump
	fi
}

pkg_postinst() {
	if systemd_is_booted || has_version sys-apps/systemd; then
		EXAMPLE="$(systemd_get_systemunitdir)/${PN}@.service.d/00gentoo.conf"

		elog "A systemd service template has been installed. To automatically start"
		elog "${PN} for mainnet at boot:"

		if ! [ -e /etc/credstore/ethereum/mainnet/jwt.hex ]; then
			elog
			elog '	# Generate an authentication token.'
			elog '	OLDMASK="$(umask)"; umask 0077'
			elog '	mkdir -p /etc/credstore/ethereum/mainnet'
			elog '	od -vN 32 -An -tx1 /dev/urandom \'
			elog '		| tr -d " \\n" > /etc/credstore/ethereum/mainnet/jwt.hex'
			elog '	umask "$OLDMASK"'
		fi

		elog
		elog '	# Enable the service.'
		elog "	systemctl enable ${PN}@mainnet.service"
		elog
		elog '	# Start the service.'
		elog "	systemctl start ${PN}@mainnet.service"

		elog
		elog "To configure the execution endpoint, create an override file (see"
		elog " ${EXAMPLE} for an example):"
		elog
		elog "	systemctl edit ${PN}@mainnet.service"
	else
		ewarn "Only a systemd service unit has been installed. ${PN} will not"
		ewarn "automatically start at boot."
	fi
}
