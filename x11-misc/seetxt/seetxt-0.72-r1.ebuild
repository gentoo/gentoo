# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Clever, lightweight GUI text file and manual page viewer for X windows"
HOMEPAGE="https://code.google.com/p/seetxt/ http://seetxt.sourceforge.net/"
SRC_URI="https://seetxt.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="virtual/pkgconfig"
RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PV}-0001-fix-linking.patch"
	"${FILESDIR}/${PV}-0002-fix-shared-files-install.patch"
	"${FILESDIR}/${PN}-0.72-fno-common.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	dodir /usr/share/man/man1
	default
	sed -i -e 's|local/||' "${D}/usr/share/seetxt-runtime/filelist" || die "sed failed"
}
