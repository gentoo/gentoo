# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
RDEPEND="${RDEPEND}
	acct-group/davfs2
	acct-user/davfs2
"

src_prepare() {
	local f

	# Let the package manager handle man page compression
	while IFS="" read -d $'\0' -r f ; do
		sed -e '/^manual[58]_DATA/ s/[.]gz//g' -i "${f}" || die
	done < <(find "${S}"/man -type f -name 'Makefile.in' -print0)

	eapply "${FILESDIR}"/${PN}-1.5.5-gcc-10.patch \
		   "${FILESDIR}"/${P}-neon31-support.patch

	default
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
