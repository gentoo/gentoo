# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 systemd

DESCRIPTION="Daemon for monitoring and adaptive tuning of system devices"
HOMEPAGE="https://fedorahosted.org/tuned/"
SRC_URI="https://fedorahosted.org/releases/t/u/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CDEPEND="
	${PYTHON_DEPS}
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/pyudev[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]"

DEPEND="
	${CDEPEND}"

RDEPEND="
	${CDEPEND}
	sys-apps/dbus
	sys-apps/ethtool
	sys-power/powertop
	sys-process/procps
	dev-util/systemtap"

PATCHES=(
	"${FILESDIR}/${P}-sysctl.patch"
	"${FILESDIR}/${P}-makefile-rpm.patch"
)

RESTRICT="test"

src_prepare() {
	default

	sed -i \
		-e "/\$(DESTDIR)\/run\/tuned/d" \
		Makefile || die
}

src_install() {
	default

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	python_fix_shebang "${ED}"
}
