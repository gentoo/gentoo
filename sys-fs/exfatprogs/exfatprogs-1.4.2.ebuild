# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Userspace utilities for the exFAT filesystem"
HOMEPAGE="https://github.com/exfatprogs/exfatprogs"

if [[ ${PV} == *9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/exfatprogs/exfatprogs.git"
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/hclee.asc
	inherit verify-sig

	SRC_URI="
		https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.xz
		verify-sig? ( https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.xz.asc )
	"

	KEYWORDS="~amd64 ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-hclee )"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	!sys-fs/exfat-utils
	sys-apps/util-linux
	elibc_musl? ( sys-libs/fts-standalone )
"
DEPEND="${RDEPEND}"
BDEPEND+="
	virtual/pkgconfig
"

src_prepare() {
	default

	[[ ${PV} == *9999 ]] && eautoreconf
}

src_configure() {
	# bash for https://github.com/exfatprogs/exfatprogs/pull/372
	CONFIG_SHELL="${BROOT}"/bin/bash econf
}
