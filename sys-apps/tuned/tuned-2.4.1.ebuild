# Copyright 1999-2014 Gentoo Foundation
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
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	sys-power/powertop
	dev-util/systemtap
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	sed -i \
		-e "/^UNITDIR = /s:\$(shell rpm --eval '%{_unitdir}'):$(systemd_get_unitdir):" \
		-e "/\$(DESTDIR)\/run\/tuned/d" \
		Makefile ||die
}

src_install() {
	default
	newinitd "${FILESDIR}"/tuned.initd  tuned

	python_fix_shebang "${ED}"
}
