# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info meson pam udev xdg-utils

DESCRIPTION="The systemd project's logind, extracted to a standalone package"
HOMEPAGE="https://github.com/elogind/elogind"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC0-1.0 LGPL-2.1+ public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+acl debug doc +pam +policykit selinux"

COMMON_DEPEND="
	sys-apps/util-linux
	sys-libs/libcap
	virtual/libudev:=
	acl? ( sys-apps/acl )
	pam? ( virtual/pam )
	selinux? ( sys-libs/libselinux )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-util/gperf
	dev-util/intltool
	sys-devel/libtool
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	!sys-apps/systemd
"
PDEPEND="
	sys-apps/dbus
	policykit? ( sys-auth/polkit )
"

PATCHES=(
	"${FILESDIR}/${PN}-235.1-docs.patch"
	"${FILESDIR}/${P}-legacy-cgroupmode.patch"
	"${FILESDIR}/${P}-drop-logintest.patch" # bug 645156
)

pkg_setup() {
	local CONFIG_CHECK="~CGROUPS ~EPOLL ~INOTIFY_USER ~SIGNALFD ~TIMERFD"

	if use kernel_linux; then
		linux-info_pkg_setup
	fi
}

src_prepare() {
	default
	xdg_environment_reset
}

src_configure() {
	local rccgroupmode="$(grep rc_cgroup_mode /etc/rc.conf | cut -d '"' -f 2)"
	local cgroupmode="legacy"

	if [[ "xhybrid" = "x${rccgroupmode}" ]] ; then
		cgroupmode="hybrid"
	elif [[ "xunified" = "x${rccgroupmode}" ]] ; then
		cgroupmode="unified"
	fi

	local emesonargs=(
		-Ddocdir="${EPREFIX}/usr/share/doc/${P}"
		-Dhtmldir="${EPREFIX}/usr/share/doc/${P}/html"
		-Dpamlibdir=$(getpam_mod_dir)
		-Dudevrulesdir="$(get_udevdir)"/rules.d
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		-Drootlibdir="${EPREFIX}"/$(get_libdir)
		-Drootlibexecdir="${EPREFIX}"/$(get_libdir)/elogind
		-Drootprefix="${EPREFIX}/"
		-Dsmack=true
		-Dman=auto
		-Dhtml=$(usex doc auto false)
		-Dcgroup-controller=openrc
		-Ddefault-hierarchy=${cgroupmode}
		-Ddebug=$(usex debug elogind false)
		--buildtype $(usex debug debug release)
		-Dacl=$(usex acl true false)
		-Dpam=$(usex pam true false)
		-Dselinux=$(usex selinux true false)
		-Dbashcompletiondir="${EPREFIX}/usr/share/bash-completion/completions"
		-Dzsh-completion="${EPREFIX}/usr/share/zsh/site-functions"
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	newinitd "${FILESDIR}"/${PN}.init ${PN}

	sed -e "s/@libdir@/$(get_libdir)/" "${FILESDIR}"/${PN}.conf.in > ${PN}.conf || die
	newconfd ${PN}.conf ${PN}
}

pkg_postinst() {
	if [[ "$(rc-config list boot | grep elogind)" != "" ]]; then
		ewarn "elogind is currently started from boot runlevel."
	elif [[ "$(rc-config list default | grep elogind)" != "" ]]; then
		ewarn "elogind is currently started from default runlevel."
		ewarn "Please remove elogind from the default runlevel and"
		ewarn "add it to the boot runlevel by:"
		ewarn "# rc-update del elogind default"
		ewarn "# rc-update add elogind boot"
	else
		ewarn "elogind is currently not started from any runlevel."
		ewarn "You may add it to the boot runlevel by:"
		ewarn "# rc-update add elogind boot"
	fi
	ewarn "Alternatively you can leave elogind out of any"
	ewarn "runlevel. It will then be started automatically"
	if use pam; then
		ewarn "when the first service calls it via dbus, or the"
		ewarn "first user logs into the system."
	else
		ewarn "when the first service calls it via dbus."
	fi
}
