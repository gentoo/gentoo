# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit verify-sig

DESCRIPTION="NCurses Disk Usage"
HOMEPAGE="https://dev.yorhel.nl/ncdu"
SRC_URI="
	amd64? ( https://dev.yorhel.nl/download/ncdu-${PV}-linux-x86_64.tar.gz )
	arm? ( https://dev.yorhel.nl/download/ncdu-${PV}-linux-arm.tar.gz )
	arm64? ( https://dev.yorhel.nl/download/ncdu-${PV}-linux-aarch64.tar.gz )
	x86? ( https://dev.yorhel.nl/download/ncdu-${PV}-linux-x86.tar.gz )
	verify-sig? (
		amd64? ( https://dev.yorhel.nl/download/ncdu-${PV}-linux-x86_64.tar.gz.asc )
		arm? ( https://dev.yorhel.nl/download/ncdu-${PV}-linux-arm.tar.gz.asc )
		arm64? ( https://dev.yorhel.nl/download/ncdu-${PV}-linux-aarch64.tar.gz.asc )
		x86? ( https://dev.yorhel.nl/download/ncdu-${PV}-linux-x86.tar.gz.asc )
	)
"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64 ~x86"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-yorhel )"

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/yoranheling.asc

QA_PREBUILT="usr/bin/ncdu-bin"

src_install() {
	newbin ncdu ncdu-bin
}
