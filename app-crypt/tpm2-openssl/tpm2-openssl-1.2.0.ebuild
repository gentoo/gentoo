# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="OpenSSL Provider for TPM2 integration"
HOMEPAGE="https://github.com/tpm2-software/tpm2-openssl"
SRC_URI="https://github.com/tpm2-software/tpm2-openssl/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-crypt/tpm2-tss-3.2.0:=
	>=dev-libs/openssl-3:="
DEPEND="${RDEPEND}
	test? (
		app-crypt/swtpm[gnutls(+)]
		app-crypt/tpm2-abrmd
		app-crypt/tpm2-tools
	)"
BDEPEND="
	sys-devel/autoconf-archive
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.1-build-Fix-undefined-references-when-using-slibtool.patch"
)

src_prepare() {
	eautoreconf
	default
}

src_test() {
	dbus_run() {
		(
			# start isolated dbus session bus
			local dbus_data=$(dbus-launch --sh-syntax) || exit
			eval "${dbus_data}"

			$@
			ret=${?}

			kill "${DBUS_SESSION_BUS_PID}"
			exit "${ret}"
		) || die
	}

	tpm2_run_with_emulator() {
		local -x XDG_CONFIG_HOME="${T}"/.config/swtpm
		"${BROOT}"/usr/share/swtpm/swtpm-create-user-config-files || die

		mkdir -p "${XDG_CONFIG_HOME}"/mytpm1 || die
		local swtpm_setup_args=(
			--tpm2
			--tpmstate "${XDG_CONFIG_HOME}"/mytpm1
			--createek
			--allow-signing
			--decryption
			--create-ek-cert
			--create-platform-cert
			--lock-nvram
			--overwrite
			--display
		)
		swtpm_setup "${swtpm_setup_args[@]}" || die

		local swtpm_socket_args=(
			--tpm2
			--tpmstate dir="${XDG_CONFIG_HOME}"/mytpm1
			--flags startup-clear
			--ctrl type=unixio,path="${XDG_CONFIG_HOME}"/mytpm1/swtpm.socket.ctrl
			--server type=unixio,path="${XDG_CONFIG_HOME}"/mytpm1/swtpm.socket
			--pid file="${XDG_CONFIG_HOME}"/mytpm1/swtpm.pid
			--daemon
		)
		swtpm socket "${swtpm_socket_args[@]}" || die

		local tpm2_abrmd_args=(
			--logger=stdout
			--tcti=swtpm:path="${XDG_CONFIG_HOME}"/mytpm1/swtpm.socket
			--session
			--flush-all
		)
		tpm2-abrmd "${tpm2_abrmd_args[@]}" &

		local -x TPM2OPENSSL_TCTI="tabrmd:bus_type=session"
		local -x TPM2TOOLS_TCTI="tabrmd:bus_type=session"

		$@ || die

		# When swtpm dies, tmp2-abrmd will exit
		kill $(< "${XDG_CONFIG_HOME}"/mytpm1/swtpm.pid) || die
	}

	dbus_run tpm2_run_with_emulator make check
}

src_install() {
	default
	find "${ED}" -iname '*.la' -delete || die
}
