# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit apache-module perl-module

DESCRIPTION="A library for manipulating client request data via the Apache API"
HOMEPAGE="https://httpd.apache.org/apreq/"
SRC_URI="mirror://apache/httpd/libapreq/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="perl test"
RESTRICT="!test? ( test )"

RDEPEND="
	|| (
		dev-libs/apr-util[openssl]
		dev-libs/apr-util[nss]
	)
	perl? (
		>=dev-perl/ExtUtils-XSBuilder-0.23
		virtual/perl-version
		>=www-apache/mod_perl-2
	)
	virtual/libcrypt:="
DEPEND="
	${RDEPEND}
	test? ( dev-perl/Apache-Test )"
BDEPEND="sys-apps/file"

PATCHES=( "${FILESDIR}"/libapreq2-2.08-doc.patch )

APACHE2_MOD_FILE="module/apache2/.libs/mod_apreq2.so"
APACHE2_MOD_CONF="76_mod_apreq"
APACHE2_MOD_DEFINE="APREQ"

need_apache2

pkg_setup() {
	perl_set_version
}

src_prepare() {
	default

	sed -i -e "s/PERL \$PERL_OPTS/PERL/" acinclude.m4 aclocal.m4 configure || die
}

src_configure() {
	econf \
		--disable-static \
		--with-apache2-apxs=${APXS} \
		$(use_enable perl perl-glue)
}

src_install() {
	APACHE_MODULESDIR="/usr/$(get_libdir)/apache2/modules"
	apache-module_src_install

	emake DESTDIR="${D}" INSTALLDIRS=vendor install
	doman docs/man/man3/*.3

	perl_delete_localpod

	HTML_DOCS=( docs/html/. )
	einstalldocs
	dodoc INSTALL MANIFEST

	local f
	while IFS="" read -d $'\0' -r f ; do
		if file "${f}" | grep -i " text"; then
			sed -i -e "s:${ED}:/:g" "${f}" || die
		fi
	done < <(find "${ED}" -type f -not -name '*.so' -print0)

	find "${ED}" -name '*.la' -delete || die
}
