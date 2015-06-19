# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/davfs2/davfs2-1.4.5-r1.ebuild,v 1.6 2014/08/10 20:54:46 slyfox Exp $

EAPI="2"

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
	epatch "${FILESDIR}"/${P}-glibc212.patch
	sed -e "s/^NE_REQUIRE_VERSIONS.*29/& 30/" -i configure.ac
	eautoreconf
}

src_configure() {
	econf --enable-largefile
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS BUGS ChangeLog FAQ NEWS README README.translators THANKS TODO

	# Remove wrong locations created by install.
	rm -fr "${D}/usr/share/doc/davfs2"
	rm -fr "${D}/usr/share/davfs2"

	dodir /var/run/mount.davfs
	keepdir /var/run/mount.davfs
	fowners root:davfs2 /var/run/mount.davfs
	fperms 1774 /var/run/mount.davfs

	# Ignore nobody's home
	cat>>"${D}/etc/davfs2/davfs2.conf"<<EOF

# nobody is a system account in Gentoo
ignore_home nobody
EOF
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
