# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="A configuration management system for Xfce"
HOMEPAGE="https://www.xfce.org/projects/"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="debug perl"

RDEPEND=">=dev-libs/glib-2.42:=
	>=xfce-base/libxfce4util-4.10:=
	perl? (
		dev-lang/perl:=[-build(-)]
		dev-perl/glib-perl
	)
	!<xfce-base/xfce4-panel-4.13.1
	!<xfce-base/xfce4-settings-4.13.1"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
	perl? (
		dev-perl/ExtUtils-Depends
		dev-perl/ExtUtils-PkgConfig
	)"

src_configure() {
	local myconf=(
		$(use_enable perl perl-bindings)
		$(use_enable debug checks)
		--with-perl-options=INSTALLDIRS=vendor
	)

	xdg_environment_reset
	econf "${myconf[@]}"
}

src_compile() {
	emake OTHERLDFLAGS="${LDFLAGS}"
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

		nonfatal emake check
		ret=${?}

		kill "${DBUS_SESSION_BUS_PID}"
		exit "${ret}"
	) || die
}

src_install() {
	default
	find "${D}" -type f -name '*.la' -delete || die

	if use perl; then
		find "${ED}" -type f -name perllocal.pod -delete || die
		find "${ED}" -depth -mindepth 1 -type d -empty -delete || die
	fi
}
