# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Linux FUSE (or coda) driver that allows you to mount a WebDAV resource"
HOMEPAGE="https://savannah.nongnu.org/projects/davfs2"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="nls"
RESTRICT="test"

DEPEND="
	net-libs/neon:="
RDEPEND="
	${DEPEND}
	acct-group/davfs2
	acct-user/davfs2
	nls? (
		virtual/libintl
		virtual/libiconv
	)"
BDEPEND="
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.1-man-page-compression.patch # backport
	"${FILESDIR}"/${PN}-1.7.1-neon-version-support.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --enable-largefile $(use_enable nls)
}

pkg_postinst() {
	elog
	elog "Quick setup:"
	elog "   (as root)"
	elog "   # gpasswd -a \${your_user} davfs2"
	elog "   # echo 'https://path/to/dav /home/\${your_user}/dav davfs rw,user,noauto  0  0' >> /etc/fstab"
	elog "   (as user)"
	elog "   \$ mkdir -p ~/dav"
	elog "   \$ mount ~/dav"
	elog
}
