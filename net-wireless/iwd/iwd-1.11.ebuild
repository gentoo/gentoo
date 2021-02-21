# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic linux-info systemd

#Set this variable to the required external ell version
ELL_REQ="0.36"

if [[ ${PV} == *9999* ]]; then
	inherit autotools git-r3
	IWD_EGIT_REPO_URI="https://git.kernel.org/pub/scm/network/wireless/iwd.git"
	ELL_EGIT_REPO_URI="https://git.kernel.org/pub/scm/libs/ell/ell.git"
else
	SRC_URI="https://www.kernel.org/pub/linux/network/wireless/${P}.tar.xz"
	KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ppc ppc64 ~sparc x86"
fi

DESCRIPTION="Wireless daemon for linux"
HOMEPAGE="https://git.kernel.org/pub/scm/network/wireless/iwd.git/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+client +crda +monitor ofono wired cpu_flags_x86_aes cpu_flags_x86_ssse3
standalone systemd"

COMMON_DEPEND="
	sys-apps/dbus
	client? ( sys-libs/readline:0= )
"

[[ -z "${ELL_REQ}" ]] || COMMON_DEPEND+=" ~dev-libs/ell-${ELL_REQ}"

RDEPEND="
	${COMMON_DEPEND}
	net-wireless/wireless-regdb
	crda? ( net-wireless/crda )
	standalone? (
		systemd? ( sys-apps/systemd )
		!systemd? ( virtual/resolvconf )
	)
"

DEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig
"

[[ ${PV} == *9999* ]] && DEPEND+=" dev-python/docutils"

pkg_setup() {
	CONFIG_CHECK="
		~ASYMMETRIC_KEY_TYPE
		~ASYMMETRIC_PUBLIC_KEY_SUBTYPE
		~CFG80211
		~CRYPTO_AES
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
		~RFKILL
		~X509_CERTIFICATE_PARSER
	"
	if use crda;then
		CONFIG_CHECK="${CONFIG_CHECK} ~CFG80211_CRDA_SUPPORT"
		WARNING_CFG80211_CRDA_SUPPORT="REGULATORY DOMAIN PROBLEM: please enable CFG80211_CRDA_SUPPORT for proper regulatory domain support"
	fi

	if use amd64;then
		CONFIG_CHECK="${CONFIG_CHECK} ~CRYPTO_DES3_EDE_X86_64"
		WARNING_CRYPTO_DES3_EDE_X86_64="CRYPTO_DES3_EDE_X86_64: enable for increased performance"
	fi

	if use cpu_flags_x86_aes;then
		CONFIG_CHECK="${CONFIG_CHECK} ~CRYPTO_AES_NI_INTEL"
		WARNING_CRYPTO_AES_NI_INTEL="CRYPTO_AES_NI_INTEL: enable for increased performance"
	fi

	if use cpu_flags_x86_ssse3 && use amd64; then
		CONFIG_CHECK="${CONFIG_CHECK} ~CRYPTO_SHA1_SSSE3 ~CRYPTO_SHA256_SSSE3 ~CRYPTO_SHA512_SSSE3"
		WARNING_CRYPTO_SHA1_SSSE3="CRYPTO_SHA1_SSSE3: enable for increased performance"
		WARNING_CRYPTO_SHA256_SSSE3="CRYPTO_SHA256_SSSE3: enable for increased performance"
		WARNING_CRYPTO_SHA512_SSSE3="CRYPTO_SHA512_SSSE3: enable for increased performance"
	fi

	if use kernel_linux && kernel_is -ge 4 20; then
		CONFIG_CHECK="${CONFIG_CHECK} ~PKCS8_PRIVATE_KEY_PARSER"
	fi

	check_extra_config

	if ! use crda; then
		if use kernel_linux && kernel_is -lt 4 15; then
			ewarn "POSSIBLE REGULATORY DOMAIN PROBLEM:"
			ewarn "Regulatory domain support for kernels older than 4.15 requires crda."
		fi
		if linux_config_exists && linux_chkconfig_builtin CFG80211 &&
			[[ $(linux_chkconfig_string EXTRA_FIRMWARE) != *regulatory.db* ]]
		then
			ewarn ""
			ewarn "REGULATORY DOMAIN PROBLEM:"
			ewarn "With CONFIG_CFG80211=y (built-in), the driver won't be able to load regulatory.db from"
			ewarn " /lib/firmware, resulting in broken regulatory domain support.  Please set CONFIG_CFG80211=m"
			ewarn " or add regulatory.db and regulatory.db.p7s to CONFIG_EXTRA_FIRMWARE."
			ewarn ""
		fi
	fi
}

src_unpack() {
	if [[ ${PV} == *9999* ]] ; then
		EGIT_REPO_URI=${IWD_EGIT_REPO_URI} git-r3_src_unpack
		EGIT_REPO_URI=${ELL_EGIT_REPO_URI} EGIT_CHECKOUT_DIR=${WORKDIR}/ell git-r3_src_unpack
	else
		default
	fi
}

src_prepare() {
	default
	if [[ ${PV} == *9999* ]] ; then
		eautoreconf
	fi
}

src_configure() {
	append-cflags "-fsigned-char"
	local myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc/iwd --localstatedir="${EPREFIX}"/var
		$(use_enable client)
		$(use_enable monitor)
		$(use_enable ofono)
		$(use_enable wired)
		--enable-systemd-service
		--with-systemd-unitdir="$(systemd_get_systemunitdir)"
		--with-systemd-modloaddir="${EPREFIX}/usr/lib/modules-load.d"
		--with-systemd-networkdir="$(systemd_get_utildir)/network"
	)
	[[ ${PV} == *9999* ]] || myeconfargs+=(--enable-external-ell)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	keepdir /var/lib/${PN}

	newinitd "${FILESDIR}/iwd.initd-r1" iwd

	if use wired;then
		newinitd "${FILESDIR}/ead.initd" ead
	fi

	if [[ ${PV} == *9999* ]] ; then
		exeinto /usr/share/iwd/scripts/
		doexe test/*
	fi

	if use standalone ; then
		local iwdconf="${ED}/etc/iwd/main.conf"
		dodir /etc/iwd
		echo "[General]" > "${iwdconf}"
		echo "EnableNetworkConfiguration=true" >> "${iwdconf}"
		echo "[Network]" >> "${iwdconf}"
		echo "NameResolvingService=$(usex systemd systemd resolvconf)" >> "${iwdconf}"
		dodir /etc/conf.d
		echo "rc_provide=\"net\"" > ${ED}/etc/conf.d/iwd
	fi
}
