# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic readme.gentoo-r1 systemd

MY_PV="$(ver_rs 4 -)"
MY_PF="${PN}-${MY_PV}"
DESCRIPTION="Anonymizing overlay network for TCP"
HOMEPAGE="http://www.torproject.org/"
SRC_URI="https://www.torproject.org/dist/${MY_PF}.tar.gz
	https://archive.torproject.org/tor-package-archive/${MY_PF}.tar.gz"
S="${WORKDIR}/${MY_PF}"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~ppc-macos"
IUSE="caps doc libressl lzma +man scrypt seccomp selinux systemd tor-hardening test zstd"

DEPEND="
	dev-libs/libevent:=[ssl]
	sys-libs/zlib
	caps? ( sys-libs/libcap )
	man? ( app-text/asciidoc )
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
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

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.7.4-torrc.sample.patch
	"${FILESDIR}"/${PN}-0.3.3.2-alpha-tor.service.in.patch
)

DOCS=()

RESTRICT="!test? ( test )"

src_configure() {
	use doc && DOCS+=( README ChangeLog ReleaseNotes doc/HACKING )
	export ac_cv_lib_cap_cap_init=$(usex caps)
	econf \
		--localstatedir="${EPREFIX}/var" \
		--enable-system-torrc \
		--disable-android \
		--disable-html-manual \
		--disable-libfuzzer \
		--disable-module-dirauth \
		--enable-pic \
		--disable-rust \
		--disable-restart-debugging \
		--disable-zstd-advanced-apis  \
		$(use_enable man asciidoc) \
		$(use_enable man manpage) \
		$(use_enable lzma) \
		$(use_enable scrypt libscrypt) \
		$(use_enable seccomp) \
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
	systemd_dounit contrib/dist/tor.service

	keepdir /var/lib/tor

	fperms 750 /var/lib/tor
	fowners tor:tor /var/lib/tor

	insinto /etc/tor/
	newins "${FILESDIR}"/torrc-r2 torrc
}
