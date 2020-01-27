# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user

DESCRIPTION="Linux FUSE (or coda) driver that allows you to mount a WebDAV resource"
HOMEPAGE="https://savannah.nongnu.org/projects/davfs2"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="nls"
RESTRICT="test"

RDEPEND="dev-libs/libxml2
	net-libs/neon
	sys-libs/zlib
	nls? ( virtual/libintl virtual/libiconv )
"
DEPEND="${REPEND}
	nls? ( sys-devel/gettext )
"

pkg_setup() {
	enewgroup davfs2
}

src_prepare() {
	# Let the package manager handle man page compression
	sed -e '/^manual[58]_DATA/ s/\.gz//g' \
		-i "${S}"/man/Makefile.in || die

	# Bug: https://bugs.gentoo.org/706356
	eapply "${FILESDIR}"/${PN}-1.5.5-gcc-10.patch

	default
}

src_configure() {
	econf dav_user=nobody --enable-largefile $(use_enable nls)
}

pkg_postinst() {
	elog
	elog "Quick setup:"
	elog "   (as root)"
	elog "   # gpasswd -a \${your_user} davfs2"
	elog "   # echo 'http://path/to/dav /home/\${your_user}/dav davfs rw,user,noauto  0  0' >> /etc/fstab"
	elog "   (as user)"
	elog "   \$ mkdir -p ~/dav"
	elog "   \$ mount ~/dav"
	elog
}
