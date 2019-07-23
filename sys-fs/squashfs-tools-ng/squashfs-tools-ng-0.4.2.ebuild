# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A new set of tools for working with SquashFS images"
HOMEPAGE="https://github.com/AgentD/squashfs-tools-ng"
if [[ ${PV} = 9999* ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/AgentD/${PN}.git"
else
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc64"
	SRC_URI="https://infraroot.at/pub/squashfs/${P}.tar.xz"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="lz4 lzo selinux +xz +zlib zstd"
REQUIRED_USE="|| ( lz4 lzo xz zlib zstd )"

DEPEND="
	lz4?     ( app-arch/lz4:= )
	lzo?     ( dev-libs/lzo:= )
	xz?      ( app-arch/xz-utils:= )
	selinux? ( sys-libs/libselinux:= )
	zlib?    ( sys-libs/zlib:= )
	zstd?    ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	[[ ${PV} == "9999" ]] && eautoreconf
}

src_configure() {
	local myconf=(
		$(use_with lz4)
		$(use_with lzo)
		$(use_with selinux)
		$(use_with xz)
		$(use_with zlib gzip)
		$(use_with zstd)
	)
	econf "${myconf[@]}"
}
