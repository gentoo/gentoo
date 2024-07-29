# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="The utility to manipulate machines owner keys which managed in shim"
HOMEPAGE="https://github.com/lcp/mokutil"
SRC_URI="https://github.com/lcp/mokutil/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/openssl:=
	sys-apps/keyutils:=
	sys-libs/efivar:=
	virtual/libcrypt:="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/mokutil-0.6.0-conflict.patch )

src_prepare() {
	default
	eautoreconf
}
