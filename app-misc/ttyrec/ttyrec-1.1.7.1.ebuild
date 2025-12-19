# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="ttyrec provides tools to record and replay a terminal session"
HOMEPAGE="https://github.com/ovh/ovh-ttyrec"
SRC_URI="https://github.com/ovh/ovh-ttyrec/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/ovh-${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 ~sparc x86"
IUSE="+zstd"

RDEPEND="zstd? ( app-arch/zstd:= )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.7.1-flags.patch
)

src_configure() {
	tc-export CC
	NO_STATIC_ZSTD=1 NO_ZSTD=$(usev !zstd 1) econf
}
