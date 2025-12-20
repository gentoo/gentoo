# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 meson vala

DESCRIPTION="A configuration management system for Xfce"
HOMEPAGE="
	https://docs.xfce.org/xfce/xfconf/start
	https://gitlab.xfce.org/xfce/xfconf/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-solaris"
IUSE="debug gtk-doc +introspection test vala"
REQUIRED_USE="vala? ( introspection )"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/glib-2.72.0
	sys-apps/dbus
	>=xfce-base/libxfce4util-4.17.3:=
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-build/xfce4-dev-tools
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc)
		$(meson_use introspection)
		$(meson_feature vala)
		$(meson_use debug runtime-checks)
		-Dbash-completion-dir="$(get_bashcompdir)"
		$(meson_use test tests)
	)

	use vala && vala_setup
	meson_src_configure
}

src_test() {
	local service_dir=${HOME}/.local/share/dbus-1/services
	mkdir -p "${service_dir}" || die
	cat > "${service_dir}/org.xfce.Xfconf.service" <<-EOF || die
		[D-BUS Service]
		Name=org.xfce.Xfconf
		Exec=${S}/xfconfd/xfconfd
	EOF

	(
		# start isolated dbus session bus
		dbus_data=$(dbus-launch --sh-syntax) || exit
		eval "${dbus_data}"

		nonfatal meson_src_test
		ret=${?}

		kill "${DBUS_SESSION_BUS_PID}"
		exit "${ret}"
	) || die
}
