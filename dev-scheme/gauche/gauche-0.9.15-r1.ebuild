# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools

MY_P="${P^g}"
MY_P="${MY_P/_p/-p}"

DESCRIPTION="A Unix system friendly Scheme Interpreter"
HOMEPAGE="https://practical-scheme.net/gauche/"
SRC_URI="https://github.com/shirok/${PN^g}/releases/download/release${PV//./_}/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)8"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc x86"
IUSE="ipv6 test"
RESTRICT="!test? ( test )"

RDEPEND="net-libs/mbedtls:0=
	sys-libs/gdbm
	virtual/libcrypt:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-ext-ldflags.patch
	"${FILESDIR}"/${PN}-gauche.m4.patch
	"${FILESDIR}"/${PN}-info.patch
	"${FILESDIR}"/${PN}-xz-info.patch
)
DOCS=( AUTHORS ChangeLog HACKING.adoc README.adoc )

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable ipv6) \
		--with-ca-bundle="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt \
		--with-slib="${EPREFIX}"/usr/share/slib \
		--with-tls=mbedtls
}

src_test() {
	emake -j1 -s check
}

src_install() {
	emake DESTDIR="${D}" install-pkg install-doc
	einstalldocs
}
