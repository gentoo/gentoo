# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

if [[ ${PV} = *9999* ]]; then
	EGIT_BRANCH="v255-stable"
	EGIT_REPO_URI="https://github.com/elogind/elogind.git"
	inherit git-r3
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/V${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

inherit eapi9-ver linux-info meson pam python-any-r1 udev xdg-utils

DESCRIPTION="The systemd project's logind, extracted to a standalone package"
HOMEPAGE="https://github.com/elogind/elogind"

LICENSE="CC0-1.0 LGPL-2.1+ public-domain"
SLOT="0"
IUSE="+acl audit cgroup-hybrid debug doc +pam +policykit selinux test"
RESTRICT="!test? ( test )"

BDEPEND="
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-util/gperf
	virtual/pkgconfig
	$(python_gen_any_dep 'dev-python/jinja2[${PYTHON_USEDEP}]')
	$(python_gen_any_dep 'dev-python/lxml[${PYTHON_USEDEP}]')
"
DEPEND="
	audit? ( sys-process/audit )
	sys-apps/util-linux
	sys-libs/libcap
	virtual/libudev:=
	acl? ( sys-apps/acl )
	pam? ( sys-libs/pam )
	selinux? ( sys-libs/libselinux )
"
RDEPEND="${DEPEND}
	!sys-apps/systemd
	>=sys-apps/systemd-utils-255.7-r4[udev]
"
PDEPEND="
	sys-apps/dbus
	policykit? ( sys-auth/polkit )
"

DOCS=( README.md )

PATCHES=(
	# all downstream patches:
	"${FILESDIR}/${PN}-252.9-nodocs.patch"
	# See also:
	# https://github.com/elogind/elogind/issues/285
	"${FILESDIR}/${PN}-255.17-revert-s2idle.patch" # bug 939042
	"${FILESDIR}/${PN}-255.22-revert-openrc-user.patch" # bug 966481
	"${FILESDIR}/${PN}-255.22-musl.patch" # bug 967191
)

python_check_deps() {
	python_has_version "dev-python/jinja2[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/lxml[${PYTHON_USEDEP}]"
}

pkg_setup() {
	local CONFIG_CHECK="~CGROUPS ~EPOLL ~INOTIFY_USER ~SIGNALFD ~TIMERFD"

	use kernel_linux && linux-info_pkg_setup
}

src_prepare() {
	default
	xdg_environment_reset

	# don't cleanup /dev/shm/ on logout on logout
	# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=949698
	sed -e "s/#RemoveIPC=yes/RemoveIPC=no/" \
		-i src/login/logind.conf.in || die
}

src_configure() {
	if use cgroup-hybrid; then
		cgroupmode="hybrid"
	else
		cgroupmode="unified"
	fi

	python_setup

	EMESON_BUILDTYPE="$(usex debug debug release)"

	local emesonargs=(
		-Ddocdir="${EPREFIX}/usr/share/doc/${PF}"
		-Dhtmldir="${EPREFIX}/usr/share/doc/${PF}/html"
		-Dudevrulesdir="${EPREFIX}$(get_udevdir)"/rules.d
		--libexecdir="lib/elogind"
		--localstatedir="${EPREFIX}"/var
		-Dbashcompletiondir="${EPREFIX}/usr/share/bash-completion/completions"
		-Dman=auto
		-Dsmack=true
		-Dcgroup-controller=openrc
		-Ddefault-hierarchy=${cgroupmode}
		-Ddefault-kill-user-processes=false
		-Dacl=$(usex acl enabled disabled)
		-Daudit=$(usex audit enabled disabled)
		-Dhtml=$(usex doc auto disabled)
		-Dpam=$(usex pam enabled disabled)
		-Dpamlibdir="$(getpam_mod_dir)"
		-Dselinux=$(usex selinux enabled disabled)
		-Dtests=$(usex test true false)
		-Dutmp=$(usex elibc_musl false true)
		-Dmode=release

		# Ensure consistency between merged-usr and split-usr (bug 945965)
		-Dhalt-path="${EPREFIX}/sbin/halt"
		-Dkexec-path="${EPREFIX}/usr/sbin/kexec"
		-Dnologin-path="${EPREFIX}/sbin/nologin"
		-Dpoweroff-path="${EPREFIX}/sbin/poweroff"
		-Dreboot-path="${EPREFIX}/sbin/reboot"
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	keepdir /var/lib/elogind

	newinitd "${FILESDIR}"/${PN}.init-r1 ${PN}

	newconfd "${FILESDIR}"/${PN}.conf ${PN}
}

pkg_postinst() {
	udev_reload
	if ! use pam; then
		ewarn "${PN} will not be managing user logins/seats without USE=\"pam\"!"
		ewarn "In other words, it will be useless for most applications."
		ewarn
	fi
	if ! use policykit; then
		ewarn "loginctl will not be able to perform privileged operations without"
		ewarn "USE=\"policykit\"! That means e.g. no suspend or hibernate."
		ewarn
	fi
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

	if ver_replacing -lt 252.9; then
		elog "Starting with release 252.9 the sleep configuration is now done"
		elog "in the /etc/elogind/sleep.conf. Should you use non-default sleep"
		elog "configuration remember to migrate those to new configuration file."
	fi

	local file files
	# find custom hooks excluding known (nvidia-drivers, sys-power/tlp)
	if [[ -d "${EROOT}"/$(get_libdir)/elogind/system-sleep ]]; then
		readarray -t files < <(find "${EROOT}"/$(get_libdir)/elogind/system-sleep/ \
			-type f \( -not -iname ".keep_dir" -a \
				-not -iname "nvidia" -a \
				-not -iname "49-tlp-sleep" \) || die)
	fi
	if [[ ${#files[@]} -gt 0 ]]; then
		ewarn "*** Custom hooks in obsolete path detected ***"
		for file in "${files[@]}"; do
			ewarn "    ${file}"
		done
		ewarn "Move these custom hooks to ${EROOT}/etc/elogind/system-sleep/ instead."
	fi
}

pkg_postrm() {
	udev_reload
}
