# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit autotools python-any-r1

DESCRIPTION="Libtpms-based TPM emulator"
HOMEPAGE="https://github.com/stefanberger/swtpm"
SRC_URI="https://github.com/stefanberger/swtpm/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="fuse seccomp test"
RESTRICT="!test? ( test )"

# net-libs/gnutls[pkcs11,tools] is required otherwsie it not possible to
# provision new vTPMs. swtpm_cert spawns certttool, and upstream expects
# pkcs11 in gnutls: https://github.com/stefanberger/swtpm/issues/477.

RDEPEND="fuse? (
		dev-libs/glib:2
		sys-fs/fuse:0
	)
	seccomp? ( sys-libs/libseccomp )
	acct-group/tss
	acct-user/tss
	dev-libs/gmp:=
	dev-libs/openssl:0=
	dev-libs/json-glib
	dev-libs/libtpms
	dev-libs/libtasn1:=
	net-libs/gnutls:=[pkcs11,tools]
"

DEPEND="${RDEPEND}
	test?	(
		net-misc/socat
		dev-tcltk/expect
		)"

BDEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}/${PN}-0.6.0-fix-localca-path.patch"
	"${FILESDIR}/${PN}-0.5.0-build-sys-Remove-WError.patch"
	"${FILESDIR}/${PN}-0.8.2-slibtool.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--with-openssl \
		--with-gnutls \
		--without-selinux \
		$(use_with fuse cuse) \
		$(use_with seccomp) \
		$(use_enable test tests)
}

src_install() {
	default
	fowners -R tss:root /var/lib/swtpm-localca
	fperms 750 /var/lib/swtpm-localca
	keepdir /var/lib/swtpm-localca
	find "${D}" -name '*.la' -delete || die
}
