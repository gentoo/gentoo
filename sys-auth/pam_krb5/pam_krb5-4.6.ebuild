# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit multilib

DESCRIPTION="Kerberos V PAM Authentication Module"
HOMEPAGE="https://www.eyrie.org/~eagle/software/pam-krb5/"
SRC_URI="https://archives.eyrie.org/software/ARCHIVE/pam-krb5/pam-krb5-${PV}.tar.gz"

LICENSE="|| ( BSD-2 GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND="
	virtual/krb5
	sys-libs/pam"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P/_/-}"

src_configure() {
	econf \
		  --libdir=/$(get_libdir)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc NEWS README TODO

	rm "${D}/$(get_libdir)/security/pam_krb5.la"
}
