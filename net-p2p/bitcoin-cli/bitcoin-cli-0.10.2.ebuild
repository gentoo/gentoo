# Copyright 2010-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

BITCOINCORE_COMMITHASH="16f45600c8c372a738ffef544292864256382601"
BITCOINCORE_SRC_SUFFIX="-r1"
BITCOINCORE_LJR_PV="0.10.1"
BITCOINCORE_LJR_DATE="20150428"
BITCOINCORE_IUSE=""
inherit bash-completion-r1 bitcoincore

DESCRIPTION="Command-line client specifically designed for talking to Bitcoin Core Daemon"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
SRC_URI="${SRC_URI}
	https://raw.githubusercontent.com/bitcoin/bitcoin/v0.11.0rc3/contrib/debian/manpages/bitcoin-cli.1 -> bitcoin-cli-manpage-v0.11.0rc3.1"

src_prepare() {
	sed -i 's/have bitcoind &&//;s/^\(complete -F _bitcoind \)bitcoind \(bitcoin-cli\)$/\1\2/' contrib/bitcoind.bash-completion
	cp "${DISTDIR}/bitcoin-cli-manpage-v0.11.0rc3.1" contrib/debian/manpages/bitcoin-cli.1
	bitcoincore_src_prepare
}

src_configure() {
	bitcoincore_conf \
		--enable-util-cli
}

src_install() {
	bitcoincore_src_install

	doman contrib/debian/manpages/bitcoin-cli.1

	newbashcomp contrib/bitcoind.bash-completion ${PN}
}
