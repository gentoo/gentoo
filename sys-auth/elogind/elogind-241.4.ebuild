# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]]; then
	EGIT_BRANCH="v241-stable"
	EGIT_REPO_URI="https://github.com/elogind/elogind.git"
	inherit git-r3
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ppc ppc64 sparc x86"
fi

inherit linux-info meson pam udev xdg-utils

DESCRIPTION="The systemd project's logind, extracted to a standalone package"
HOMEPAGE="https://github.com/elogind/elogind"

LICENSE="CC0-1.0 LGPL-2.1+ public-domain"
SLOT="0"
IUSE="+acl debug doc +pam +policykit selinux"

COMMON_DEPEND="
	sys-apps/util-linux
	sys-libs/libcap
	virtual/libudev:=
	acl? ( sys-apps/acl )
	pam? ( sys-libs/pam )
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

DOCS=( NEWS README.md src/libelogind/sd-bus/GVARIANT-SERIALIZATION )

PATCHES=(
	"${FILESDIR}/${P}-nodocs.patch"
	"${FILESDIR}/${P}-broken-test.patch" # bug 699116
)

pkg_setup() {
	local CONFIG_CHECK="~CGROUPS ~EPOLL ~INOTIFY_USER ~SIGNALFD ~TIMERFD"

	use kernel_linux && linux-info_pkg_setup
}

src_prepare() {
	default
	xdg_environment_reset
}

src_configure() {
	local rccgroupmode="$(grep rc_cgroup_mode \"${EPREFIX}/etc/rc.conf\" | cut -d '"' -f 2)"
	local cgroupmode="legacy"

	if [[ "xhybrid" = "x${rccgroupmode}" ]] ; then
		cgroupmode="hybrid"
	elif [[ "xunified" = "x${rccgroupmode}" ]] ; then
		cgroupmode="unified"
	fi

	local emesonargs=(
		-Ddocdir="${EPREFIX}/usr/share/doc/${PF}"
		-Dhtmldir="${EPREFIX}/usr/share/doc/${PF}/html"
		-Dpamlibdir=$(getpam_mod_dir)
		-Dudevrulesdir="${EPREFIX}$(get_udevdir)"/rules.d
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		-Drootlibdir="${EPREFIX}"/$(get_libdir)
		-Drootlibexecdir="${EPREFIX}"/$(get_libdir)/elogind
		-Drootprefix="${EPREFIX}/"
		-Dbashcompletiondir="${EPREFIX}/usr/share/bash-completion/completions"
		-Dman=auto
		-Dsmack=true
		-Dcgroup-controller=openrc
		-Ddefault-hierarchy=${cgroupmode}
		-Ddefault-kill-user-processes=false
		-Dacl=$(usex acl true false)
		--buildtype $(usex debug debug release)
		-Dhtml=$(usex doc auto false)
		-Dpam=$(usex pam true false)
		-Dselinux=$(usex selinux true false)
		-Dutmp=$(usex elibc_musl false true)
	)

	meson_src_configure
}

src_install() {
	DOCS+=( src/libelogind/sd-bus/GVARIANT-SERIALIZATION )

	meson_src_install

	newinitd "${FILESDIR}"/${PN}.init ${PN}

	sed -e "s/@libdir@/$(get_libdir)/" "${FILESDIR}"/${PN}.conf.in > ${PN}.conf || die
	newconfd ${PN}.conf ${PN}
}

pkg_postinst() {
	if [[ "$(rc-config list boot | grep elogind)" != "" ]]; then
		elog "elogind is currently started from boot runlevel."
	elif [[ "$(rc-config list default | grep elogind)" != "" ]]; then
		ewarn "elogind is currently started from default runlevel."
		ewarn "Please remove elogind from the default runlevel and"
		ewarn "add it to the boot runlevel by:"
		ewarn "# rc-update del elogind default"
		ewarn "# rc-update add elogind boot"
	else
		elog "elogind is currently not started from any runlevel."
		elog "You may add it to the boot runlevel by:"
		elog "# rc-update add elogind boot"
		elog
		elog "Alternatively, you can leave elogind out of any"
		elog "runlevel. It will then be started automatically"
		if use pam; then
			elog "when the first service calls it via dbus, or"
			elog "the first user logs into the system."
		else
			elog "when the first service calls it via dbus."
		fi
	fi
}
