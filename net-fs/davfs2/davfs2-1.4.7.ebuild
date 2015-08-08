# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools eutils linux-mod user

DESCRIPTION="Linux FUSE (or coda) driver that allows you to mount a WebDAV resource"
HOMEPAGE="http://savannah.nongnu.org/projects/davfs2"
SRC_URI="http://mirror.lihnidos.org/GNU/savannah/davfs2/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
RESTRICT="test"

DEPEND="dev-libs/libxml2
		net-libs/neon
		sys-libs/zlib"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup davfs2
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-destdir.patch # fixed in 1.4.7+ upstream
	sed -e "s/^NE_REQUIRE_VERSIONS.*29/& 30/" -i configure.ac
	eautoreconf
}

src_configure() {
	econf dav_user=nobody --enable-largefile --docdir=/usr/share/doc/${P}
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install
#	dodoc AUTHORS BUGS ChangeLog FAQ NEWS README README.translators THANKS TODO

	dodir /var/run/mount.davfs
	keepdir /var/run/mount.davfs
	fowners root:davfs2 /var/run/mount.davfs
	fperms 1774 /var/run/mount.davfs

}

pkg_postinst() {
	elog
	elog "Quick setup:"
	elog "   (as root)"
	elog "   # gpasswd -a \${your_user} davfs2"
	elog "   # echo 'http://path/to/dav /home/\${your_user}/dav davfs rw,user,noauto  0  0' >> /etc/fstab"
	elog "   (as user)"
	elog "   # mkdir -p ~/dav"
	elog "   \$ mount ~/dav"
	elog
}
