# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

COMMIT=170f61ba706688e41a3b5a2f1f571f4eba323fcc
MY_P=${PN}-${COMMIT}

DESCRIPTION="Rsync-bpc is a customized version of rsync that is used as part of BackupPC"
HOMEPAGE="https://github.com/backuppc/rsync-bpc"
SRC_URI="https://github.com/backuppc/rsync-bpc/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="acl lz4 xxhash"

RDEPEND="
	virtual/ssh
	>=dev-libs/popt-1.5
	acl? ( virtual/acl )
	lz4? ( app-arch/lz4:= )
	xxhash? ( >=dev-libs/xxhash-0.8 )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-autoconf.patch"
	"${FILESDIR}/${P}-acls.patch"
)

src_prepare() {
	default

	eautoreconf
}

src_configure(){
	local myconf=(
		--disable-md2man
		--without-included-popt
		--enable-ipv6
		--without-included-zlib
		$(use_enable acl acl-support)
		$(use_enable lz4)
		$(use_enable xxhash)
	)

	econf "${myconf[@]}"
}
