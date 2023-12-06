# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Tools for Flash-Friendly File System (F2FS)"
HOMEPAGE="https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git/about/"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/${PN}.git"
	EGIT_BRANCH="dev"
else
	SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/${PN}.git/snapshot/${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv x86"
fi

LICENSE="GPL-2"
SLOT="0/10"
IUSE="lz4 lzo selinux"

RDEPEND="
	lz4? ( app-arch/lz4:= )
	lzo? ( dev-libs/lzo:2 )
	sys-apps/util-linux
	selinux? ( sys-libs/libselinux )
	elibc_musl? ( sys-libs/queue-standalone )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-musl-1.2.4-lfs.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		# This is required to install to /sbin, bug #481110
		--bindir="${EPREFIX}"/sbin
		$(use_with lz4)
		$(use_with lzo lzo2)
		$(use_with selinux)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
}
