# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

# This corresponds to a commit between 0.3.0 and 0.4.0!
GIT_HASH="e19adc575c1f9d8f08b7fbc594a0887ace63f83f"
DESCRIPTION="The utility to manipulate machines owner keys which managed in shim"
HOMEPAGE="https://github.com/lcp/mokutil"
SRC_URI="https://github.com/lcp/mokutil/archive/${GIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${GIT_HASH}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/openssl:=
	sys-libs/efivar:=
	virtual/libcrypt:="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}
