# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit eutils python-single-r1

DESCRIPTION="Allow manipulating events before/after insertion as well as before fetching"
HOMEPAGE="https://launchpad.net/zeitgeist-extensions/"
SRC_URI="http://launchpad.net/${PN}/trunk/fts-${PV}/+download/${P}.tar.gz"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3"
IUSE="fts geolocation memprofile sqldebug tracker"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	fts? (
		!gnome-extra/zeitgeist[fts]
		dev-libs/xapian-bindings[python]
		dev-python/dbus-python
		dev-python/pygobject
		dev-python/pyxdg
	)
	geolocation? (
		dev-python/dbus-python
		dev-python/python-geoclue
	)
	memprofile? (
		dev-python/dbus-python
		dev-python/pympler
	)
	sqldebug? ( dev-python/python-sqlparse )
	tracker? (
		app-misc/tracker
		dev-python/pygobject
		dev-python/dbus-python
	)"

PATCHES=(
		"${FILESDIR}"/${P}-python.patch \
		"${FILESDIR}"/${P}-gobject.patch
)

src_prepare() {
	epatch "${PATCHES[@]}"
}

src_install() {
	python_moduleinto /usr/share/zeitgeist/_zeitgeist/engine/extensions
	use fts && python_domodule ./fts/fts.py
	if use geolocation; then
		dodoc ./geolocation/example.py
		python_domodule ./geolocation/geolocation.py
	fi
	if use memprofile; then
		python_domodule ./memory-profile/profile_memory.py
		newdoc ./memory-profile/README README-memprofile
	fi
	use sqldebug && python_domodule ./debug_sql/debug_sql.py
	use tracker && python_domodule ./tracker/tracker.py

	python_optimize "${ED}"/usr/share/zeitgeist/_zeitgeist/engine/extensions
}
