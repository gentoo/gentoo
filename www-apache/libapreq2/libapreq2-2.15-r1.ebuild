# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit apache-module perl-module

DESCRIPTION="A library for manipulating client request data via the Apache API"
SRC_URI="mirror://apache/httpd/libapreq/${P}.tar.gz"
HOMEPAGE="https://httpd.apache.org/apreq/"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ~ppc ppc64 x86"
IUSE="perl test"
RESTRICT="!test? ( test )"

RDEPEND="
	|| (
		dev-libs/apr-util[openssl]
		dev-libs/apr-util[libressl]
		dev-libs/apr-util[nss]
	)
	perl? (
		>=dev-perl/ExtUtils-XSBuilder-0.23
		virtual/perl-version
		>=www-apache/mod_perl-2
	)
"
DEPEND="${RDEPEND}
	test? ( dev-perl/Apache-Test )
"

PATCHES=(
	"${FILESDIR}"/libapreq2-2.08-doc.patch
)

APACHE2_MOD_FILE="module/apache2/.libs/mod_apreq2.so"
APACHE2_MOD_CONF="76_mod_apreq"
APACHE2_MOD_DEFINE="APREQ"
DOCFILES="docs/html/*.html CHANGES README INSTALL MANIFEST"

need_apache2

pkg_setup() {
	perl_set_version
}

src_prepare() {
	default

	sed -i -e "s/PERL \$PERL_OPTS/PERL/" "${S}"/acinclude.m4 || die
	sed -i -e "s/PERL \$PERL_OPTS/PERL/" "${S}"/aclocal.m4 || die
	sed -i -e "s/PERL \$PERL_OPTS/PERL/" "${S}"/configure  || die
}

src_configure() {
	econf \
		--with-apache2-apxs=${APXS} \
		$(use_enable perl perl-glue)
}

src_install() {
	APACHE_MODULESDIR="/usr/$(get_libdir)/apache2/modules"
	apache-module_src_install

	make DESTDIR="${D}" INSTALLDIRS=vendor install || die "make install failed"
	doman docs/man/man3/*.3

	perl_delete_localpod

	for i in $(find "${D}" -type f -not -name '*.so'); do
		if file ${i} | grep -i " text"; then
			sed -i -e "s:${D}:/:g" ${i} || die
		fi
	done
}
