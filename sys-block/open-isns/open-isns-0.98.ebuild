# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="iSNS server and client for Linux"
HOMEPAGE="https://github.com/open-iscsi/open-isns"
SRC_URI="https://github.com/open-iscsi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~mips ppc ppc64 sparc x86"
IUSE="debug libressl slp ssl static"

DEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	slp? ( net-libs/openslp )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-libressl-compatibility.patch" )

src_configure() {
	use debug && append-cppflags -DDEBUG_TCP -DDEBUG_SCSI
	append-lfs-flags
	econf $(use_with slp) \
		$(use_with ssl security) \
		$(use_enable !static shared)
}

src_install() {
	default
	emake DESTDIR="${D}" install_hdrs
	emake DESTDIR="${D}" install_lib
}
