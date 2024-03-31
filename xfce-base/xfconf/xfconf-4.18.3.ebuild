# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 vala

DESCRIPTION="A configuration management system for Xfce"
HOMEPAGE="
	https://docs.xfce.org/xfce/xfconf/start
	https://gitlab.xfce.org/xfce/xfconf/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0/3"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="debug +introspection vala"
REQUIRED_USE="vala? ( introspection )"

DEPEND="
	>=dev-libs/glib-2.66.0
	sys-apps/dbus
	>=xfce-base/libxfce4util-4.17.3:=
	introspection? ( >=dev-libs/gobject-introspection-1.66:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_configure() {
	local myconf=(
		$(use_enable introspection)
		$(use_enable vala)
		$(use_enable debug checks)
		--with-bash-completion-dir="$(get_bashcompdir)"
	)

	use vala && vala_setup
	econf "${myconf[@]}"
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

		# -j>1 often hangs
		# https://gitlab.xfce.org/xfce/xfconf/-/issues/13
		nonfatal emake -j1 check
		ret=${?}

		kill "${DBUS_SESSION_BUS_PID}"
		exit "${ret}"
	) || die
}

src_install() {
	default
	find "${D}" -type f -name '*.la' -delete || die
}
