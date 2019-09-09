# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${P/-/}"
DESCRIPTION="BNC (BouNCe) is used as a gateway to an IRC Server"
HOMEPAGE="http://gotbnc.com/"
SRC_URI="http://gotbnc.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ppc ppc64 ~s390 sparc x86"
IUSE="ssl"

DEPEND="ssl? ( dev-libs/openssl:0= )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/respect-cflags-ldflags.patch"
	"${FILESDIR}/${PN}-2.9.3-64bit.patch"
)

src_prepare() {
	default
	sed -i -e 's:./mkpasswd:/usr/bin/bncmkpasswd:' bncsetup \
		|| die 'failed to rename mkpasswd in bncsetup'
}

src_configure() {
	econf $(use_with ssl)
}

src_install() {
	default
	mv "${ED}"/usr/bin/{,bnc}mkpasswd \
		|| die 'failed to rename the mkpasswd executable'
	dodoc example.conf motd
}

pkg_postinst() {
	einfo 'You can find an example motd/conf file here:'
	einfo " /usr/share/doc/${PF}"
}
