# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Simple MTP fuse filesystem driver"
HOMEPAGE="https://github.com/phatina/simple-mtpfs"
SRC_URI="https://github.com/phatina/simple-mtpfs/archive/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/libmtp
	sys-fs/fuse:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	default

	# The tarball doesn't contain ./configure, only configure.ac and
	# autogen.sh.
	eautoreconf
}
