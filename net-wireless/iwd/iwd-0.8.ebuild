# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools linux-info systemd

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/network/wireless/iwd.git"
	inherit git-r3
else
	SRC_URI="https://www.kernel.org/pub/linux/network/wireless/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Wireless daemon for linux"
HOMEPAGE="https://git.kernel.org/pub/scm/network/wireless/iwd.git/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+client +monitor ofono wired cpu_flags_x86_aes cpu_flags_x86_ssse3"

RDEPEND="sys-apps/dbus
	client? ( sys-libs/readline:0= )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_pretend() {
	CONFIG_CHECK="
		~ASYMMETRIC_KEY_TYPE
		~ASYMMETRIC_PUBLIC_KEY_SUBTYPE
		~CRYPTO_AES
		~CRYPTO_ARC4
		~CRYPTO_CBC
		~CRYPTO_CMAC
		~CRYPTO_DES
		~CRYPTO_ECB
		~CRYPTO_HMAC
		~CRYPTO_MD4
		~CRYPTO_MD5
		~CRYPTO_RSA
		~CRYPTO_SHA1
		~CRYPTO_SHA256
		~CRYPTO_SHA512
		~CRYPTO_USER_API_HASH
		~CRYPTO_USER_API_SKCIPHER
		~KEY_DH_OPERATIONS
		~PKCS7_MESSAGE_PARSER
		~X509_CERTIFICATE_PARSER
	"
	if use amd64;then
		CONFIG_CHECK="${CONFIG_CHECK} ~CRYPTO_AES_X86_64 ~CRYPTO_DES3_EDE_X86_64"
		WARNING_CRYPTO_AES_X86_64="CRYPTO_AES_X86_64: enable for increased performance"
		WARNING_CRYPTO_DES3_EDE_X86_64="CRYPTO_DES3_EDE_X86_64: enable for increased performance"
	fi

	if use cpu_flags_x86_aes;then
		CONFIG_CHECK="${CONFIG_CHECK} ~CRYPTO_AES_NI_INTEL"
		WARNING_CRYPTO_AES_NI_INTEL="CRYPTO_AES_NI_INTEL: enable for increased performance"
	fi

	if use cpu_flags_x86_ssse3; then
		CONFIG_CHECK="${CONFIG_CHECK} ~CRYPTO_SHA1_SSSE3 ~CRYPTO_SHA256_SSSE3 ~CRYPTO_SHA512_SSSE3"
		WARNING_CRYPTO_SHA1_SSSE3="CRYPTO_SHA1_SSSE3: enable for increased performance"
		WARNING_CRYPTO_SHA256_SSSE3="CRYPTO_SHA256_SSSE3: enable for increased performance"
		WARNING_CRYPTO_SHA512_SSSE3="CRYPTO_SHA512_SSSE3: enable for increased performance"
	fi

	check_extra_config
}

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git-r3_src_unpack
		git clone git://git.kernel.org/pub/scm/libs/ell/ell.git "${WORKDIR}"/ell
	else
		default
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --sysconfdir=/etc/iwd --localstatedir=/var \
		$(use_enable client) \
		$(use_enable monitor) \
		$(use_enable ofono) \
		$(use_enable wired) \
		--enable-systemd-service \
		--with-systemd-unitdir="$(systemd_get_systemunitdir)"
}

src_install() {
	default
	keepdir /var/lib/${PN}

	newinitd "${FILESDIR}/iwd.initd" iwd

	if [[ ${PV} == "9999" ]] ; then
		exeinto /usr/share/iwd/scripts/
		doexe test/*
	fi
}
