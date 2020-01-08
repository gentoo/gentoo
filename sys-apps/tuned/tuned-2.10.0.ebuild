# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 systemd

DESCRIPTION="Daemon for monitoring and adaptive tuning of system devices"
HOMEPAGE="https://fedorahosted.org/tuned/"
SRC_URI="https://github.com/redhat-performance/tuned/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CDEPEND="
	${PYTHON_DEPS}
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/pyudev[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/python-linux-procfs[${PYTHON_USEDEP}]"

DEPEND="
	${CDEPEND}"

RDEPEND="
	${CDEPEND}
	sys-apps/dbus
	sys-apps/ethtool
	sys-power/powertop
	sys-process/procps
	dev-util/systemtap"

RESTRICT="test"

src_prepare() {
	default

	sed -i \
		-e "/^PYTHON/s/= python3/= python2/g" \
		-e "/^DOCDIR/s/$/&\-\$(VERSION)/g" \
		-e "/\$(DESTDIR)\/run\/tuned/d" \
		-e "/\$(DESTDIR)\/var\/lib\/tuned/d" \
		-e "/\$(DESTDIR)\/var\/log\/tuned/d" \
		Makefile || die
}

src_install() {
	default

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	python_fix_shebang "${ED}"
}
