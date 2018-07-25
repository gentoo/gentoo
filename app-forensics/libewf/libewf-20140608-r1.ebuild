# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit eutils autotools-utils

DESCRIPTION="Implementation of the EWF (SMART and EnCase) image format"
HOMEPAGE="https://github.com/libyal/libewf"
SRC_URI="https://googledrive.com/host/0B3fBvzttpiiSMTdoaVExWWNsRjg/${P}.tar.gz
	https://dev.gentoo.org/~gokturk/distfiles/app-forensics/libewf/libewf-20140608-libuna-remove-inline.patch"

LICENSE="BSD"
SLOT="0/2"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
# upstream bug #2597171, pyewf has implicit declarations
#IUSE="debug python unicode"
IUSE="bfio debug ewf +fuse +ssl static-libs +uuid unicode zlib"

DEPEND="
	sys-libs/zlib
	bfio? ( =app-forensics/libbfio-0.0.20120425_alpha )
	fuse? ( sys-fs/fuse:= )
	uuid? ( sys-apps/util-linux )
	ssl? ( dev-libs/openssl:0= )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${DISTDIR}"/${P}-libuna-remove-inline.patch
	"${FILESDIR}"/${PN}-20140608-fix-tmpdir-in-tests.patch
)

DOCS=( AUTHORS ChangeLog NEWS README documents/header.txt documents/header2.txt )

src_configure() {
	local myeconfargs=(
		$(use_enable debug debug-output)
		$(use_enable debug verbose-output)
		$(use_enable ewf v1-api)
		$(use_enable unicode wide-character-type)
		$(use_with zlib)
		# autodetects bzip2 but does not use
		--without-bzip2
		$(use_with bfio libbfio)
		$(use_with ssl openssl)
		$(use_with uuid libuuid)
		$(use_with fuse libfuse)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	doman manuals/*.1 manuals/*.3
}
