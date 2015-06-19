# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam-pgsql/pam-pgsql-0.7.3.1.ebuild,v 1.4 2014/12/28 16:56:37 titanofold Exp $

EAPI=2

inherit eutils pam

DESCRIPTION="pam_pgsql is a module for pam to authenticate users with PostgreSQL"
HOMEPAGE="http://sourceforge.net/projects/pam-pgsql/"

if [[ ${PV} = *_p* ]]; then
	SRC_URI="http://www.flameeyes.eu/gentoo-distfiles/${P}.tar.gz"
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
fi

RDEPEND="virtual/pam
	>=dev-db/postgresql-8.0
	>=dev-libs/libgcrypt-1.2.0:0"
DEPEND="${RDEPEND}"

LICENSE="GPL-2"

IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_configure() {
	econf \
		--sysconfdir=/etc/security \
		--libdir=/$(get_libdir) \
		--docdir=/usr/share/doc/${PF} || die "econf failed"
}

src_compile() {
	emake pammoddir="$(getpam_mod_dir)" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" pammoddir="$(getpam_mod_dir)" install || die "emake install failed"
	find "${D}" -name '*.la' -delete
}

pkg_postinst() {
	elog "Please see the documentation and configuration examples in the"
	elog "documentation directory at /usr/share/doc/${PF}."
	elog ""
	elog "Please note that the default configuration file in Gentoo has been"
	elog "moved to /etc/security/pam-pgsql.conf to follow the other PAM modules."
}
