# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library handling the communication with Apple's Tatsu Signing Server (TSS)."
HOMEPAGE="https://libimobiledevice.org/"

SRC_URI="https://github.com/libimobiledevice/libtatsu/releases/download/${PV}/libtatsu-${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~loong ppc ~ppc64 ~riscv ~s390 x86"

RDEPEND="
	app-pda/libplist
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}
