# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit autotools distutils-r1

DESCRIPTION="Libtpms-based TPM emulator"
HOMEPAGE="https://github.com/stefanberger/swtpm"
SRC_URI="https://github.com/stefanberger/swtpm/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fuse gnutls seccomp test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	fuse? (
		dev-libs/glib:2
		sys-fs/fuse:0
	)
	gnutls? (
		dev-libs/libtasn1:=
		>=net-libs/gnutls-3.1.0[tools]
	)
	dev-libs/openssl:0=
	dev-libs/libtpms
	seccomp? ( sys-libs/libseccomp )
"

DEPEND="${COMMON_DEPEND}
	test? (
		net-misc/socat
		dev-tcltk/expect
	)
"

RDEPEND="${COMMON_DEPEND}
	acct-group/tss
	acct-user/tss
	dev-python/cryptography[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-0.5.0-fix-localca-path.patch"
	"${FILESDIR}/${PN}-0.5.0-build-sys-Remove-WError.patch"
)

src_prepare() {
	use test || eapply "${FILESDIR}/${PN}-0.5.0-disable-test-dependencies.patch"
	python_setup
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--with-openssl \
		--without-selinux \
		$(use_with fuse cuse) \
		$(use_with gnutls) \
		$(use_with seccomp)
}

src_compile() {
	# We want the default src_compile, not the version distutils-r1 exports
	default
}

src_install() {
	default
	python_foreach_impl python_optimize
	fowners -R tss:root /var/lib/swtpm-localca
	fperms 750 /var/lib/swtpm-localca
	keepdir /var/lib/swtpm-localca
	find "${D}" -name '*.la' -delete || die
}

src_test() {
	# We want the default src_test, not the version distutils-r1 exports
	default
}
