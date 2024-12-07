# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit autotools guile

DESCRIPTION="Guile-GnuTLS provides Guile bindings for the GnuTLS library"
HOMEPAGE="https://gnutls.gitlab.io/guile/manual/
	https://gitlab.com/gnutls/guile/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.com/gnutls/guile.git"
else
	SRC_URI="https://gitlab.com/gnutls/guile/-/archive/v${PV}/guile-v${PV}.tar.bz2
		-> ${P}.tar.bz2"
	S="${WORKDIR}/guile-v${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"

REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="
	${GUILE_DEPS}
	net-libs/gnutls:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	guile_src_prepare
	eautoreconf
}

src_configure() {
	my_configure() {
		# --disable-srp-authentication: bug #894050
		econf --disable-srp-authentication guile_snarf=${GUILESNARF}
	}
	guile_foreach_impl my_configure
}

src_install() {
	guile_src_install

	find "${ED}" -type f -name "*.la" -delete || die
}
