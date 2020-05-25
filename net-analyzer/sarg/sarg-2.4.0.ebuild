# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic

DESCRIPTION="Squid Analysis Report Generator"
HOMEPAGE="https://sourceforge.net/projects/sarg/"
SRC_URI="mirror://sourceforge/${PN}/${P/_/-}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ppc ~x86"
SLOT="0"
IUSE="bzip2 doublecheck +gd +glob ldap lzma pcre zlib"

RDEPEND="
	bzip2? ( app-arch/bzip2 )
	gd? ( media-libs/gd[png,truetype] )
	ldap? ( net-nds/openldap )
	lzma? ( app-arch/xz-utils )
	pcre? ( dev-libs/libpcre )
	zlib? ( sys-libs/zlib )
"
DEPEND="
	${RDEPEND}
"
DOCS=( BETA-TESTERS CONTRIBUTORS DONATIONS README ChangeLog htaccess )
PATCHES=(
	"${FILESDIR}"/${PN}-2.4.0-config.patch
	"${FILESDIR}"/${PN}-2.4.0-configure.patch
	"${FILESDIR}"/${PN}-2.4.0-fabs.patch
	"${FILESDIR}"/${PN}-2.4.0-format.patch
)
S=${WORKDIR}/${P/_/-}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	append-cflags -fcommon
	econf \
		$(use_enable doublecheck) \
		$(use_with bzip2 bzlib) \
		$(use_with gd) \
		$(use_with glob) \
		$(use_with ldap) \
		$(use_with lzma liblzma) \
		$(use_with pcre) \
		$(use_with zlib) \
		--sysconfdir="${EPREFIX}/etc/sarg/"
}

src_install() {
	default

	dodoc documentation/*
}
