# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/alisarctl.asc
inherit autotools verify-sig

DESCRIPTION="Linux FUSE (or coda) driver that allows you to mount a WebDAV resource"
HOMEPAGE="https://savannah.nongnu.org/projects/davfs2"
SRC_URI="
	mirror://nongnu/${PN}/${P}.tar.gz
	verify-sig? ( mirror://nongnu/${PN}/${P}.tar.gz.sig )
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="nls verify-sig"
RESTRICT="test"

RDEPEND="dev-libs/libxml2:=
	acct-group/davfs2
	acct-user/davfs2
	net-libs/neon:0/27
	virtual/zlib:=
	nls? ( virtual/libintl virtual/libiconv )
"
BDEPEND="
	nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-alisarctl )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.1-neon-version-support.patch
)

src_prepare() {
	local f

	# Let the package manager handle man page compression
	while IFS="" read -d $'\0' -r f ; do
		sed -e '/^manual[58]_DATA/ s/[.]gz//g' -i "${f}" || die
	done < <(find "${S}"/man -type f -name 'Makefile.am' -print0)

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
