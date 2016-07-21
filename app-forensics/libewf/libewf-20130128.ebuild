# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

DESCRIPTION="Implementation of the EWF (SMART and EnCase) image format"
HOMEPAGE="https://github.com/libyal/libewf"
SRC_URI="https://libewf.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/2"
KEYWORDS="amd64 hppa ppc x86"
# upstream bug #2597171, pyewf has implicit declarations
#IUSE="debug python rawio unicode"
IUSE="debug ewf +fuse rawio +ssl static-libs +uuid unicode zlib"

DEPEND="
	sys-libs/zlib
	fuse? ( sys-fs/fuse )
	uuid? ( sys-apps/util-linux )
	ssl? ( dev-libs/openssl )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

DOCS=( AUTHORS ChangeLog NEWS README documents/header.txt documents/header2.txt )

src_configure() {
	local myeconfargs=(
		$(use_enable debug debug-output)
		$(use_enable debug verbose-output)
		$(use_enable ewf v1-api)
		$(use_enable rawio low-level-functions)
		$(use_enable unicode wide-character-type)
		$(use_with zlib)
		# autodetects bzip2 but does not use
		--without-bzip2
		#if we don't force disable this then it fails to build against new libbfio
		--without-libbfio
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
