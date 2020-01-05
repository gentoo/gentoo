# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit autotools python-any-r1

DESCRIPTION="Libtpms-based TPM emulator"
HOMEPAGE="https://github.com/stefanberger/swtpm"
SRC_URI="https://github.com/stefanberger/swtpm/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fuse gnutls seccomp test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="dev-libs/libtpms
	dev-libs/openssl:0
	fuse? (
		dev-libs/glib:2
		sys-fs/fuse:0
	      )
	gnutls? (
		   dev-libs/libtasn1:=
		   >=net-libs/gnutls-3.1.0[tools]
		)
	seccomp? ( sys-libs/libseccomp )
"

DEPEND="${COMMON_DEPEND}
	test? (
		net-misc/socat
		${PYTHON_DEPS}
	      )
"

RDEPEND="${COMMON_DEPEND}
	app-crypt/tpm-tools
	app-crypt/trousers
	dev-tcltk/expect"

src_prepare() {
	use test || eapply "${FILESDIR}/${PN}-disable-test-dependencies.patch"
	eapply "${FILESDIR}/${PN}-fix-localca-path.patch"
	default
	eautoreconf
}

src_configure() {
	econf \
	  --with-openssl \
	  --without-selinux \
	  $(use_with fuse cuse) \
	  $(use_with gnutls) \
	  $(use_with seccomp)
}

src_install() {
	default
	fowners tss:tss /var/lib/swtpm-localca
	keepdir /var/lib/swtpm-localca
}
