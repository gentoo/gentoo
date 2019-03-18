# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils flag-o-matic

MY_P="imap-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Mail utilities from the UW"
HOMEPAGE="http://www.washington.edu/imap/"
SRC_URI="ftp://ftp.cac.washington.edu/imap/${MY_P}.tar.Z"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 s390 sparc x86 ~x86-fbsd"
IUSE="pam ssl"

DEPEND="pam? ( virtual/pam )
	ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}
	!<net-mail/uw-imap-${PV}"

src_prepare() {
	chmod -R ug+w "${S}"

	epatch "${FILESDIR}/${PN}-2004g.patch"
	epatch "${FILESDIR}/${PN}-ssl.patch"

	# no interactive build
	sed -i -e "/read x; case/s/^/#/" Makefile || die

	sed -i -e "s|\`cat \$C/CFLAGS\`|${CFLAGS}|g" \
		src/mailutil/Makefile \
		src/mtest/Makefile || die "sed failed patching Makefile CFLAGS."

	append-flags -fPIC
}

src_compile() {
	local port=slx
	use elibc_FreeBSD && port=bsf
	use pam && port=lnp
	local ssltype=none
	use ssl && ssltype=nopwd
	emake -j1 "${port}" EXTRACFLAGS="${CFLAGS}" EXTRALDFLAGS="${LDFLAGS}" SSLTYPE="${ssltype}"
}

src_install() {
	dobin mailutil/mailutil mtest/mtest
	doman src/mailutil/mailutil.1
}
