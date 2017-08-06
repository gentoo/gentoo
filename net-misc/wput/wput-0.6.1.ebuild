# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="Tiny program like wget, to upload files/whole directories via FTP"
HOMEPAGE="http://wput.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="debug nls ssl"

RDEPEND="ssl? ( net-libs/gnutls )"
DEPEND="${RDEPEND}
		nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-0.6-gentoo.diff"
	# Fix bug 126828
	epatch "${FILESDIR}/wput-0.6-respectldflags.patch"
}

src_compile() {
	local myconf
	use debug && myconf="--enable-memdbg=yes" || myconf="--enable-g-switch=no"
	econf ${myconf} \
		$(use_enable nls) \
		$(use_with ssl) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog INSTALL TODO
}
