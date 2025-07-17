# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )

inherit bash-completion-r1 gnome2 meson-multilib python-any-r1 vala virtualx

DESCRIPTION="GObject library for accessing the freedesktop.org Secret Service API"
HOMEPAGE="https://gnome.pages.gitlab.gnome.org/libsecret"

LICENSE="LGPL-2.1+ test? ( || ( GPL-2+ Apache-2.0 ) )"
SLOT="0"

KEYWORDS="~alpha amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv sparc ~x86"
IUSE="+crypt +gcrypt gnutls gtk-doc +introspection pam test test-rust tpm +vala"

RESTRICT="!test? ( test )"
REQUIRED_USE="
	vala? ( introspection )
	gtk-doc? ( crypt )
	crypt? ( || ( gcrypt gnutls ) )
"

DEPEND="
	!<app-shells/bash-completion-2.16.0-r1
	>=dev-libs/glib-2.44:2[${MULTILIB_USEDEP}]
	gcrypt? ( >=dev-libs/libgcrypt-1.2.2:0=[${MULTILIB_USEDEP}] )
	gnutls? ( >=net-libs/gnutls-3.8.2:0=[${MULTILIB_USEDEP}] )
	pam? ( sys-libs/pam )
	tpm? ( >=app-crypt/tpm2-tss-3.0.3:= )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
RDEPEND="${DEPEND}"
PDEPEND="virtual/secret-service"
BDEPEND="
	app-text/docbook-xml-dtd:4.2
	dev-libs/libxslt
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? (
		app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gi-docgen-2021.7
	)
	pam? ( sys-libs/pam_wrapper )
	test? (
		$(python_gen_any_dep '
			dev-python/dbus-python[${PYTHON_USEDEP}]
			introspection? ( dev-python/pygobject:3[${PYTHON_USEDEP}] )')
		test-rust? ( introspection? ( >=dev-libs/gjs-1.32 ) )
		tpm? (
			app-crypt/swtpm
			app-crypt/tpm2-abrmd
			>=app-crypt/tpm2-tss-3.2.0:=
		)
	)
	vala? ( $(vala_depend) )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.21.7-optional-tests.patch
	"${FILESDIR}"/${PN}-0.21.7-optional-vala-tests.patch
)

dbus_run() {
	(
		# start isolated dbus session bus
		dbus_data=$(dbus-launch --sh-syntax) || exit
		eval "${dbus_data}"

		$@
		ret=${?}

		kill "${DBUS_SESSION_BUS_PID}"
		exit "${ret}"
	) || die
}

tpm2_run_with_emulator() {
	export XDG_CONFIG_HOME=${T}/.config/swtpm
	"${BROOT}"/usr/share/swtpm/swtpm-create-user-config-files --overwrite || die

	mkdir -p ${XDG_CONFIG_HOME}/mytpm1 || die
	swtpm_setup_args=(
		--tpm2
		--tpmstate ${XDG_CONFIG_HOME}/mytpm1
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

	swtpm_socket_args=(
		--tpm2
		--tpmstate dir=${XDG_CONFIG_HOME}/mytpm1
		--flags startup-clear
		--ctrl type=unixio,path=${XDG_CONFIG_HOME}/mytpm1/swtpm.socket.ctrl
		--server type=unixio,path=${XDG_CONFIG_HOME}/mytpm1/swtpm.socket
		--pid file=${XDG_CONFIG_HOME}/mytpm1/swtpm.pid
		--daemon
	)
	swtpm socket "${swtpm_socket_args[@]}" || die

	tpm2_abrmd_args=(
		--logger=stdout
		--tcti=swtpm:path=${XDG_CONFIG_HOME}/mytpm1/swtpm.socket
		--session
		--flush-all
	)
	tpm2-abrmd "${tpm2_abrmd_args[@]}" &
	export TCTI=tabrmd:bus_type=session

	$@ || die

	# When swtpm dies, tmp2-abrmd will exit
	kill $(< ${XDG_CONFIG_HOME}/mytpm1/swtpm.pid) || die
}

python_check_deps() {
	if use introspection; then
		python_has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]" || return
	fi
	python_has_version "dev-python/dbus-python[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	use vala && vala_setup
	default
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_true manpage)
		$(meson_native_use_bool vala vapi)
		$(meson_native_use_bool gtk-doc gtk_doc)
		$(meson_native_use_bool introspection)
		-Dbashcompdir="$(get_bashcompdir)"
		-Dbash_completion=enabled
		$(meson_native_use_bool tpm tpm2)
		$(meson_native_use_bool pam)
		$(meson_feature test test_setup)
	)

	if use crypt ; then
		use gcrypt && emesonargs+=( -Dcrypto=libgcrypt )
		use gnutls && emesonargs+=( -Dcrypto=gnutls )
	else
		emesonargs+=( -Dcrypto=disabled )
	fi

	meson_src_configure
}

multilib_src_test() {
	if use tpm; then
		dbus_run tpm2_run_with_emulator virtx meson test -C "${BUILD_DIR}"
	else
		virtx dbus-run-session meson test -C "${BUILD_DIR}"
	fi
}
