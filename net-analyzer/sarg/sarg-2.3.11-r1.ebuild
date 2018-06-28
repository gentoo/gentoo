# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Squid Analysis Report Generator"
HOMEPAGE="http://sarg.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc x86"
SLOT="0"
IUSE="+gd ldap pcre"

DEPEND="
	gd? ( media-libs/gd[png,truetype] )
	ldap? ( net-nds/openldap )
	pcre? ( dev-libs/libpcre )
"
RDEPEND="
	${DEPEND}
"
DOCS=( BETA-TESTERS CONTRIBUTORS DONATIONS README ChangeLog htaccess )
PATCHES=(
	"${FILESDIR}"/${PN}-2.3.10-config.patch
	"${FILESDIR}"/${PN}-2.3.11-configure.patch
	"${FILESDIR}"/${PN}-2.3.11-format.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_with gd) \
		$(use_with ldap) \
		$(use_with pcre) \
		--sysconfdir="${EPREFIX}/etc/sarg/"
}
