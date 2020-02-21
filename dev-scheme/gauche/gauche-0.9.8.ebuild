# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools eapi7-ver

MY_P="${P^g}"

DESCRIPTION="A Unix system friendly Scheme Interpreter"
HOMEPAGE="http://practical-scheme.net/gauche/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tgz"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)7"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="ipv6 libressl mbedtls test"
RESTRICT="!test? ( test )"

RDEPEND="sys-libs/gdbm
	mbedtls? ( net-libs/mbedtls:= )"
DEPEND="${RDEPEND}
	test? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl:0 )
	)"
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-ext-ldflags.patch
	"${FILESDIR}"/${PN}-gauche.m4.patch
	"${FILESDIR}"/${PN}-info.patch
	"${FILESDIR}"/${PN}-rfc.tls.patch
	"${FILESDIR}"/${PN}-xz-info.patch
)
DOCS=( AUTHORS ChangeLog HACKING.adoc README.adoc )

src_prepare() {
	default
	use ipv6 && sed -i "s/ -4//" ext/tls/ssltest-mod.scm

	eautoconf
}

src_configure() {
	econf \
		$(use_enable ipv6) \
		--with-ca-bundle="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt \
		--with-libatomic-ops=no \
		--with-slib="${EPREFIX}"/usr/share/slib \
		--with-tls=axtls$(usex mbedtls ',mbedtls' '')
}

src_test() {
	emake -j1 -s check
}

src_install() {
	emake DESTDIR="${D}" install-pkg install-doc
	einstalldocs
}
