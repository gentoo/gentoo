# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/libgssglue.asc
inherit readme.gentoo-r1 verify-sig

DESCRIPTION="Exports a gssapi interface which calls other random gssapi libraries"
HOMEPAGE="
	http://www.citi.umich.edu/projects/nfsv4/linux/
	https://gitlab.com/gsasl/libgssglue
"
# Linked from https://gitlab.com/gsasl/libgssglue/-/releases/libgssglue-0.9
SRC_URI="
	https://gitlab.com/-/project/37744631/uploads/7310f7060cdf240a4b8eaaf80a435986/${P}.tar.gz
	verify-sig? ( https://gitlab.com/-/project/37744631/uploads/7d3596d0e6fdecc2fb5b5e74edaedb37/${P}.tar.gz.sig )
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="virtual/krb5"

DOC_CONTENTS="
This package allows choosing a Kerberos or GSSAPI implementation
at runtime.

See
https://blog.josefsson.org/2022/07/14/towards-pluggable-gss-api-modules/
for more details.

A system-wide implementation can be chosen by editing ${EPREFIX}/etc/gssapi_mech.conf,
or it can be set per-process via the GSSAPI_MECH_CONF environment variable.
"

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
