# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

MY_PN="RigoDaemon"
DESCRIPTION="Entropy Client DBus Services, aka RigoDaemon"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
SRC_URI="mirror://sabayon/sys-apps/entropy-${PV}.tar.bz2"

S="${WORKDIR}/entropy-${PV}/rigo/${MY_PN}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${PYTHON_DEPS}
	dev-python/dbus-python
	dev-python/pygobject:3
	~sys-apps/entropy-${PV}[${PYTHON_USEDEP}]
	sys-auth/polkit[introspection]
	sys-devel/gettext"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	python_optimize "${D}/usr/lib/rigo/${MY_PN}"
}

pkg_preinst() {
	# ask RigoDaemon to shutdown, if running
	# TODO: this will be removed in future
	local shutdown_exec=${EROOT}/usr/lib/rigo/${MY_PN}/shutdown.py
	[[ -x "${shutdown_exec}" ]] && "${shutdown_exec}"
}
