# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="The utility to manipulate machines owner keys which managed in shim"
HOMEPAGE="https://github.com/lcp/mokutil"
GIT_HASH="e19adc575c1f9d8f08b7fbc594a0887ace63f83f"
SRC_URI="https://github.com/lcp/mokutil/archive/${GIT_HASH}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl:=
	sys-libs/efivar:="
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${GIT_HASH}"

src_prepare() {
	default
	eautoreconf
}
