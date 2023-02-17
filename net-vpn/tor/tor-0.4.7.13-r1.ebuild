# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/torproject.org.asc
inherit python-any-r1 readme.gentoo-r1 systemd verify-sig

MY_PV="$(ver_rs 4 -)"
MY_PF="${PN}-${MY_PV}"
DESCRIPTION="Anonymizing overlay network for TCP"
HOMEPAGE="https://www.torproject.org/ https://gitlab.torproject.org/tpo/core/tor/"
SRC_URI="
	https://www.torproject.org/dist/${MY_PF}.tar.gz
	https://archive.torproject.org/tor-package-archive/${MY_PF}.tar.gz
	verify-sig? (
		https://dist.torproject.org/${MY_PF}.tar.gz.sha256sum
		https://dist.torproject.org/${MY_PF}.tar.gz.sha256sum.asc
	)
"
S="${WORKDIR}/${MY_PF}"

LICENSE="BSD GPL-2"
SLOT="0"
if [[ ${PV} != *_alpha* && ${PV} != *_beta* && ${PV} != *_rc* ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~sparc x86 ~ppc-macos"
fi
IUSE="caps doc lzma +man scrypt seccomp selinux +server systemd tor-hardening test zstd"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/libevent-2.1.12-r1:=[ssl]
	sys-libs/zlib
	caps? ( sys-libs/libcap )
	man? ( app-text/asciidoc )
	dev-libs/openssl:=[-bindist(-)]
	lzma? ( app-arch/xz-utils )
	scrypt? ( app-crypt/libscrypt )
	seccomp? ( >=sys-libs/libseccomp-2.4.1 )
	systemd? ( sys-apps/systemd )
	zstd? ( app-arch/zstd )
"
RDEPEND="
	acct-user/tor
	acct-group/tor
	${DEPEND}
	selinux? ( sec-policy/selinux-tor )
"
DEPEND+="
	test? (
		${DEPEND}
		${PYTHON_DEPS}
	)
"
BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-tor-20221213 )"

DOCS=()

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.7.4-torrc.sample.patch
)

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

src_prepare() {
	default

	# Running shellcheck automagically isn't useful for ebuild testing.
	echo "exit 0" > scripts/maint/checkShellScripts.sh || die
}

src_configure() {
	use doc && DOCS+=( README.md ChangeLog ReleaseNotes doc/HACKING )

	export ac_cv_lib_cap_cap_init=$(usex caps)
	export tor_cv_PYTHON="${EPYTHON}"

	local myeconfargs=(
		--localstatedir="${EPREFIX}/var"
		--disable-all-bugs-are-fatal
		--enable-system-torrc
		--disable-android
		--disable-coverage
		--disable-html-manual
		--disable-libfuzzer
		--enable-missing-doc-warnings
		--disable-module-dirauth
		--enable-pic
		--disable-restart-debugging
		--disable-zstd-advanced-apis
		$(use_enable man asciidoc)
		$(use_enable man manpage)
		$(use_enable lzma)
		$(use_enable scrypt libscrypt)
		$(use_enable seccomp)
		$(use_enable server module-relay)
		$(use_enable systemd)
		$(use_enable tor-hardening gcc-hardening)
		$(use_enable tor-hardening linker-hardening)
		$(use_enable test unittests)
		$(use_enable zstd)
	)

	econf "${myeconfargs[@]}"
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
