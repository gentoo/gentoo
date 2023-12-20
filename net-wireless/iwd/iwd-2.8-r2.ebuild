# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit flag-o-matic linux-info systemd

#Set this variable to the required external ell version
ELL_REQ="0.58"

if [[ ${PV} == *9999* ]]; then
	inherit autotools git-r3
	IWD_EGIT_REPO_URI="https://git.kernel.org/pub/scm/network/wireless/iwd.git"
	ELL_EGIT_REPO_URI="https://git.kernel.org/pub/scm/libs/ell/ell.git"
else
	SRC_URI="https://mirrors.edge.kernel.org/pub/linux/network/wireless/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"
	MYRST2MAN="RST2MAN=:"
fi

DESCRIPTION="Wireless daemon for linux"
HOMEPAGE="https://git.kernel.org/pub/scm/network/wireless/iwd.git/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+client cpu_flags_x86_aes cpu_flags_x86_ssse3 +monitor ofono selinux standalone systemd wired"

DEPEND="
	sys-apps/dbus
	client? ( sys-libs/readline:0= )
"

[[ -z "${ELL_REQ}" ]] || DEPEND+=" >=dev-libs/ell-${ELL_REQ}"

RDEPEND="
	${DEPEND}
	acct-group/netdev
	net-wireless/wireless-regdb
	selinux? ( sec-policy/selinux-networkmanager )
	standalone? (
		systemd? ( sys-apps/systemd )
		!systemd? ( virtual/resolvconf )
	)
"

BDEPEND="
	virtual/pkgconfig
"

[[ ${PV} == *9999* ]] && BDEPEND+=" dev-python/docutils"

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

	sed -e "s:Exec=/bin/false:Exec=${EPREFIX}/usr/libexec/iwd:g" -i src/net.connman.iwd.service || die
}

src_configure() {
	append-cflags "-fsigned-char"
	local myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc/iwd --localstatedir="${EPREFIX}"/var
		"$(use_enable client)"
		"$(use_enable monitor)"
		"$(use_enable ofono)"
		"$(use_enable wired)"
		--enable-systemd-service
		--with-systemd-unitdir="$(systemd_get_systemunitdir)"
		--with-systemd-modloaddir="${EPREFIX}/usr/lib/modules-load.d"
		--with-systemd-networkdir="$(systemd_get_utildir)/network"
	)
	[[ ${PV} == *9999* ]] || myeconfargs+=(--enable-external-ell)
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake "${MYRST2MAN}"
}

src_install() {
	emake DESTDIR="${D}" "${MYRST2MAN}" install
	keepdir "/var/lib/${PN}"

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
		cat << EOF > "${iwdconf}"
[General]
EnableNetworkConfiguration=true

[Network]
NameResolvingService=$(usex systemd systemd resolvconf)
EOF
		dodir /etc/conf.d
		echo "rc_provide=\"net\"" > "${ED}"/etc/conf.d/iwd
	fi
}
