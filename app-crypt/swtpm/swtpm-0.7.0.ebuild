# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )

inherit autotools python-single-r1

DESCRIPTION="Libtpms-based TPM emulator"
HOMEPAGE="https://github.com/stefanberger/swtpm"
SRC_URI="https://github.com/stefanberger/swtpm/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="fuse +gnutls seccomp test"
RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="fuse? (
		dev-libs/glib:2
		sys-fs/fuse:0
	)
	gnutls? (
		dev-libs/libtasn1:=
		>=net-libs/gnutls-3.1.0:=[tools,pkcs11]
	)
	seccomp? ( sys-libs/libseccomp )
	acct-group/tss
	acct-user/tss
	dev-libs/openssl:0=
	dev-libs/json-glib
	dev-libs/libtpms
	${PYTHON_DEPS}"

DEPEND="${RDEPEND}
	test? (
		net-misc/socat
		dev-tcltk/expect
	)"

PATCHES=(
	"${FILESDIR}/${PN}-0.6.0-fix-localca-path.patch"
	"${FILESDIR}/${PN}-0.5.0-build-sys-Remove-WError.patch"
)

src_prepare() {
	use test || eapply "${FILESDIR}/${PN}-0.5.0-disable-test-dependencies.patch"
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
	fowners -R tss:root /var/lib/swtpm-localca
	fperms 750 /var/lib/swtpm-localca
	keepdir /var/lib/swtpm-localca
	find "${D}" -name '*.la' -delete || die
}
