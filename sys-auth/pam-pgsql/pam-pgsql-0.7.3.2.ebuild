# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils pam

DESCRIPTION="pam module to authenticate users via PostgreSQL"
HOMEPAGE="http://sourceforge.net/projects/pam-pgsql/"

if [[ ${PV} == *_p* ]]; then
	SRC_URI="http://www.flameeyes.eu/gentoo-distfiles/${P}.tar.gz"
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
fi

RDEPEND="virtual/pam
	>=dev-db/postgresql-8.0:=
	>=dev-libs/libgcrypt-1.2.0:0="
DEPEND="${RDEPEND}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_configure() {
	econf \
		--sysconfdir=/etc/security \
		--libdir=/$(get_libdir) \
		--docdir=/usr/share/doc/${PF}
}

src_compile() {
	emake pammoddir="$(getpam_mod_dir)" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" pammoddir="$(getpam_mod_dir)" install
	find "${ED}" -name '*.la' -delete
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "Please see the documentation and configuration examples in the"
		elog "documentation directory at /usr/share/doc/${PF}."
		elog ""
		elog "Please note that the default configuration file in Gentoo has been"
		elog "moved to /etc/security/pam-pgsql.conf to follow the other PAM modules."
	fi
}
