# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit optfeature python-single-r1 tmpfiles xdg-utils

DESCRIPTION="Daemon for monitoring and adaptive tuning of system devices"
HOMEPAGE="https://github.com/redhat-performance/tuned"
SRC_URI="https://github.com/redhat-performance/tuned/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/configobj[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/decorator[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/python-linux-procfs[${PYTHON_USEDEP}]
		dev-python/pyudev[${PYTHON_USEDEP}]
	')"

RDEPEND="
	${DEPEND}
	app-emulation/virt-what
	dev-debug/systemtap
	sys-apps/dbus
	sys-apps/ethtool
	sys-power/powertop
	"

RESTRICT="test"

src_prepare() {
	default

	sed -i \
		-e "/^PYTHON/s:/usr/bin/python3:${EPREFIX}/usr/bin/${EPYTHON}:" \
		-e "/^export DOCDIR/s/$/&\-\$(VERSION)/g" \
		-e "/\$(DESTDIR)\/run\/tuned/d" \
		-e "/\$(DESTDIR)\/var\/lib\/tuned/d" \
		-e "/\$(DESTDIR)\/var\/log\/tuned/d" \
		Makefile || die
}

src_install() {
	default

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	python_fix_shebang "${D}"
	python_optimize
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
	xdg_icon_cache_update

	optfeature_header
	optfeature "Optimize for power saving by spinning-down rotational disks" sys-apps/hdparm
	optfeature "Get hardware info" sys-apps/dmidecode
	optfeature "Optimize network txqueuelen" sys-apps/iproute2
}
