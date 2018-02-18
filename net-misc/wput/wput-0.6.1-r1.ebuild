# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tiny program like wget, to upload files/whole directories via FTP"
HOMEPAGE="http://wput.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE="debug nls ssl"

RDEPEND="ssl? ( net-libs/gnutls )"

DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}/${PN}-0.6-gentoo.diff"
	"${FILESDIR}/${PN}-0.6-respectldflags.patch"
)

DOCS=( ChangeLog INSTALL TODO )

src_configure() {
	local myconf="--enable-g-switch=no"
	use debug && myconf="--enable-memdbg=yes"
	econf \
		$(use_enable nls) \
		$(use_with ssl) \
		"${myconf}"
}

src_install() {
	default
}
