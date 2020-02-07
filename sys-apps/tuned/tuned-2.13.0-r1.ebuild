# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit python-single-r1 xdg-utils

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
		dev-python/configobj[${PYTHON_MULTI_USEDEP}]
		dev-python/decorator[${PYTHON_MULTI_USEDEP}]
		dev-python/pyudev[${PYTHON_MULTI_USEDEP}]
		dev-python/dbus-python[${PYTHON_MULTI_USEDEP}]
		dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
		dev-python/python-linux-procfs[${PYTHON_MULTI_USEDEP}]
	')"

RDEPEND="
	${DEPEND}
	sys-apps/dbus
	sys-apps/ethtool
	sys-power/powertop
	dev-util/systemtap"

RESTRICT="test"

src_prepare() {
	default

	sed -i \
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
	xdg_icon_cache_update
}
