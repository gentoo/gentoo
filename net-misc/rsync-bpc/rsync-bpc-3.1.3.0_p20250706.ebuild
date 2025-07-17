# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

COMMIT=ed6c77370ebd6e2bbd986606757146941ada6857
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
	"${FILESDIR}/${PN}-3.1.3.0-fix-gettimeofday-error.patch" #874666
	"${FILESDIR}/${PN}-3.1.3.0-fix-qsort-call.patch" #944357
	"${FILESDIR}/${PN}-3.1.3.0-fix-xattr-warning.patch" #854612
)

src_prepare() {
	default
	sed -i -e 's/AC_HEADER_MAJOR_FIXED/AC_HEADER_MAJOR/' configure.ac
	eaclocal -I m4
	eautoconf -o configure.sh
}

src_configure(){
	econf \
		--disable-md2man \
		--without-included-popt \
		--enable-ipv6 \
		$(use_enable acl acl-support) \
		$(use_enable lz4) \
		$(use_enable xxhash)
}
