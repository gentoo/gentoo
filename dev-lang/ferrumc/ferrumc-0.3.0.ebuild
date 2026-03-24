# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v3

EAPI=8

DESCRIPTION="Ferrum-language compiler with compile-time memory safety"
HOMEPAGE="https://ferrum-language.github.io/Ferrum/"

SRC_URI="
	amd64? ( https://github.com/Ferrum-Language/Ferrum/releases/download/v${PV}/ferrumc-v${PV}-linux-x86_64.tar.gz -> ferrumc-${PV}-linux-amd64.tar.gz )
	arm64? ( https://github.com/Ferrum-Language/Ferrum/releases/download/v${PV}/ferrumc-v${PV}-linux-aarch64.tar.gz -> ferrumc-${PV}-linux-arm64.tar.gz )
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
RESTRICT="strip"

QA_PREBUILT="usr/bin/ferrumc"

src_unpack() {
	default
}

src_install() {
	dobin ferrumc
}
