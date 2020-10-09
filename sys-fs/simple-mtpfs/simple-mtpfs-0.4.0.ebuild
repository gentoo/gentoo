# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Simple MTP fuse filesystem driver"
HOMEPAGE="https://github.com/phatina/simple-mtpfs"
SRC_URI="https://github.com/phatina/simple-mtpfs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	media-libs/libmtp
	sys-fs/fuse:0"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/autoconf-archive
	virtual/pkgconfig"

src_prepare() {
	default

	# The tarball doesn't contain ./configure, only configure.ac and
	# autogen.sh.
	eautoreconf
}
