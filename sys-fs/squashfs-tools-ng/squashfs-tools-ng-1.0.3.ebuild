# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A new set of tools for working with SquashFS images"
HOMEPAGE="https://github.com/AgentD/squashfs-tools-ng"
if [[ ${PV} = 9999* ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/AgentD/${PN}.git"
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
	SRC_URI="https://infraroot.at/pub/squashfs/${P}.tar.xz"
fi

LICENSE="LGPL-3+ tools? ( GPL-3+ )"
SLOT="0"
IUSE="lz4 lzo selinux +tools +xz zstd"

DEPEND="
	sys-libs/zlib:=
	lz4?     ( app-arch/lz4:= )
	lzo?     ( dev-libs/lzo:= )
	xz?      ( app-arch/xz-utils:= )
	selinux? ( sys-libs/libselinux:= )
	zstd?    ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	[[ ${PV} == "9999" ]] && eautoreconf
}

src_configure() {
	local myconf=(
		--disable-static
		$(use_with lz4)
		$(use_with lzo)
		$(use_with selinux)
		$(use_with tools)
		$(use_with xz)
		$(use_with zstd)
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name "*.la" -delete || die
}
