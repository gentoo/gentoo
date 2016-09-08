# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 systemd

DESCRIPTION="Daemon for monitoring and adaptive tuning of system devices"
HOMEPAGE="https://fedorahosted.org/tuned/"
SRC_URI="https://fedorahosted.org/releases/t/u/tuned/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="${PYTHON_DEPS}
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/pyudev[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	sys-apps/dbus
	sys-apps/ethtool
	sys-power/powertop
	sys-process/procps
	dev-util/systemtap
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-sysctl.patch

	sed -i \
		-e "/\$(DESTDIR)\/run\/tuned/d" \
		Makefile ||die
}

src_install() {
	default
	newinitd "${FILESDIR}"/tuned.initd  tuned

	python_fix_shebang "${ED}"
}
