# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/dshaw.asc
inherit verify-sig

DESCRIPTION="OpenPGP key archiver"
HOMEPAGE="https://www.jabberwocky.com/software/paperkey/"
SRC_URI="
	https://www.jabberwocky.com/software/${PN}/${P}.tar.gz
	verify-sig? ( https://www.jabberwocky.com/software/${PN}/${P}.tar.gz.sig )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86 ~x64-macos"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-dshaw )"
