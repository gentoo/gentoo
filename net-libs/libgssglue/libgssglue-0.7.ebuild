# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools readme.gentoo-r1

DESCRIPTION="Exports a gssapi interface which calls other random gssapi libraries"
HOMEPAGE="http://www.citi.umich.edu/projects/nfsv4/linux https://gitlab.com/gsasl/libgssglue"
SRC_URI="https://gitlab.com/gsasl/libgssglue/-/archive/${P}/${PN}-${P}.tar.bz2"
S="${WORKDIR}"/${PN}-${P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="virtual/krb5"

DOC_CONTENTS="
This package allows choosing a Kerberos or GSSAPI implementation
at runtime.

See
https://blog.josefsson.org/2022/07/14/towards-pluggable-gss-api-modules/
for more details.

A system-wide implementation can be chosen by editing ${EROOT}/etc/gssapi_mech.conf,
or it can be set per-process via the GSSAPI_MECH_CONF environment variable.
"

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default

	readme.gentoo_create_doc

	insinto /etc
	doins doc/gssapi_mech.conf

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	readme.gentoo_print_elog
}
