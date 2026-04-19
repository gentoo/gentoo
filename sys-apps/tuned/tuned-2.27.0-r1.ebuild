# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit optfeature python-single-r1 tmpfiles toolchain-funcs xdg

DESCRIPTION="Daemon for monitoring and adaptive tuning of system devices"
HOMEPAGE="https://github.com/redhat-performance/tuned"
SRC_URI="https://github.com/redhat-performance/tuned/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="+ppd"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-emulation/virt-what
	dev-debug/systemtap
	sys-apps/dbus
	sys-apps/ethtool
	sys-power/powertop
	$(python_gen_cond_dep '
		dev-python/configobj[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/decorator[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/python-linux-procfs[${PYTHON_USEDEP}]
		dev-python/pyudev[${PYTHON_USEDEP}]
	')
	ppd? (
		!sys-power/power-profiles-daemon
		$(python_gen_cond_dep '
			dev-python/pyinotify[${PYTHON_USEDEP}]
		')
	)
"

src_compile() { :; }

src_test() {
	eunittest tests/unit
}

src_install() {
	local sitedir="$(python_get_sitedir)"
	local myemakeargs=(
		DESTDIR="${ED}"
		DOCDIR="/usr/share/doc/${PF}"
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
		PYTHON_SITELIB="${sitedir#${EPREFIX}}"
		rewrite_shebang=true
	)
	emake "${myemakeargs[@]}" install $(usev ppd install-ppd)

	einstalldocs

	# 934664
	dodir /etc/tuned/profiles

	rm -r "${ED}"/run "${ED}"/var || die

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	python_fix_shebang "${ED}"
	python_optimize
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
	xdg_pkg_postinst

	optfeature_header
	optfeature "Optimize for power saving by spinning-down rotational disks" sys-apps/hdparm
	optfeature "Get hardware info" sys-apps/dmidecode
	optfeature "Optimize network txqueuelen" sys-apps/iproute2
	# tuned-gui.py calls systemctl
	has_version sys-apps/systemd && optfeature "GTK gui" x11-libs/gtk+:3[introspection]
}
