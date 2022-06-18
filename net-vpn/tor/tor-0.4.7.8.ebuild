# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PYTHON_COMPAT=( python3_{8..10} )
inherit python-any-r1 readme.gentoo-r1 systemd verify-sig

MY_PV="$(ver_rs 4 -)"
MY_PF="${PN}-${MY_PV}"
DESCRIPTION="Anonymizing overlay network for TCP"
HOMEPAGE="https://www.torproject.org/"
SRC_URI="https://www.torproject.org/dist/${MY_PF}.tar.gz
	https://archive.torproject.org/tor-package-archive/${MY_PF}.tar.gz
	verify-sig? (
		https://dist.torproject.org/${MY_PF}.tar.gz.sha256sum
		https://dist.torproject.org/${MY_PF}.tar.gz.sha256sum.asc
	)"
S="${WORKDIR}/${MY_PF}"

LICENSE="BSD GPL-2"
SLOT="0"
if [[ ${PV} != *_alpha* && ${PV} != *_beta* && ${PV} != *_rc* ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ~mips ppc ~ppc64 ~riscv ~sparc x86 ~ppc-macos"
fi
IUSE="caps doc lzma +man scrypt seccomp selinux +server systemd tor-hardening test zstd"
VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/torproject.org.asc

BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-tor-20220216 )"
DEPEND="
	dev-libs/libevent:=[ssl]
	sys-libs/zlib
	caps? ( sys-libs/libcap )
	man? ( app-text/asciidoc )
	dev-libs/openssl:0=[-bindist(-)]
	lzma? ( app-arch/xz-utils )
	scrypt? ( app-crypt/libscrypt )
	seccomp? ( >=sys-libs/libseccomp-2.4.1 )
	systemd? ( sys-apps/systemd )
	zstd? ( app-arch/zstd )"
RDEPEND="
	acct-user/tor
	acct-group/tor
	${DEPEND}
	selinux? ( sec-policy/selinux-tor )"

# bug #764260
DEPEND+="
	test? (
		${DEPEND}
		${PYTHON_DEPS}
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.7.4-torrc.sample.patch
)

DOCS=()

RESTRICT="!test? ( test )"

# EAPI 8 tries to append it but it doesn't exist here
# bug #831311 etc
QA_CONFIGURE_OPTIONS="--disable-static"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_unpack() {
	if use verify-sig; then
		cd "${DISTDIR}" || die
		verify-sig_verify_detached ${MY_PF}.tar.gz.sha256sum{,.asc}
		verify-sig_verify_unsigned_checksums \
			${MY_PF}.tar.gz.sha256sum sha256 ${MY_PF}.tar.gz
		cd "${WORKDIR}" || die
	fi

	default
}

src_configure() {
	use doc && DOCS+=( README.md ChangeLog ReleaseNotes doc/HACKING )
	export ac_cv_lib_cap_cap_init=$(usex caps)
	econf \
		--localstatedir="${EPREFIX}/var" \
		--disable-all-bugs-are-fatal \
		--enable-system-torrc \
		--disable-android \
		--disable-html-manual \
		--disable-libfuzzer \
		--enable-missing-doc-warnings \
		--disable-module-dirauth \
		--enable-pic \
		--disable-restart-debugging \
		--disable-zstd-advanced-apis  \
		$(use_enable man asciidoc) \
		$(use_enable man manpage) \
		$(use_enable lzma) \
		$(use_enable scrypt libscrypt) \
		$(use_enable seccomp) \
		$(use_enable server module-relay) \
		$(use_enable systemd) \
		$(use_enable tor-hardening gcc-hardening) \
		$(use_enable tor-hardening linker-hardening) \
		$(use_enable test unittests) \
		$(use_enable test coverage) \
		$(use_enable zstd)
}

src_install() {
	default
	readme.gentoo_create_doc

	newconfd "${FILESDIR}"/tor.confd tor
	newinitd "${FILESDIR}"/tor.initd-r9 tor
	systemd_dounit "${FILESDIR}"/tor.service

	keepdir /var/lib/tor

	fperms 750 /var/lib/tor
	fowners tor:tor /var/lib/tor

	insinto /etc/tor/
	newins "${FILESDIR}"/torrc-r2 torrc
}
