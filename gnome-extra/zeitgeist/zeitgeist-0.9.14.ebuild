# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/zeitgeist/zeitgeist-0.9.14.ebuild,v 1.5 2015/04/08 17:56:30 mgorny Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=true
PYTHON_COMPAT=( python2_7 )

VALA_MIN_API_VERSION=0.20

inherit autotools-utils bash-completion-r1 eutils python-r1 versionator vala

DIR_PV=$(get_version_component_range 1-2)

DESCRIPTION="Service to log activities and present to other apps"
HOMEPAGE="http://launchpad.net/zeitgeist/"
SRC_URI="http://launchpad.net/zeitgeist/${DIR_PV}/${PV}/+download/${P}.tar.xz"

LICENSE="LGPL-2+ LGPL-3+ GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="+datahub downloads-monitor extensions +fts icu introspection nls plugins sql-debug telepathy"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	downloads-monitor? ( datahub )"

RDEPEND="
	${PYTHON_DEPS}
	!gnome-extra/zeitgeist-datahub
	dev-libs/json-glib
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/rdflib[${PYTHON_USEDEP}]
	media-libs/raptor:2
	>=dev-libs/glib-2.26.0:2
	>=dev-db/sqlite-3.7.11:3
	sys-apps/dbus
	datahub? ( x11-libs/gtk+:3 )
	extensions? ( gnome-extra/zeitgeist-extensions  )
	fts? ( dev-libs/xapian[inmemory] )
	icu? ( dev-libs/dee[icu?,${PYTHON_USEDEP}] )
	introspection? ( dev-libs/gobject-introspection )
	plugins? ( gnome-extra/zeitgeist-datasources )
	telepathy? ( net-libs/telepathy-glib )
"
DEPEND="${RDEPEND}
	$(vala_depend)
	virtual/pkgconfig"

src_prepare() {
	local PYTHON
	python_export_best
	sed \
		-e 's:python::g' \
		-i Makefile.am || die
	vala_src_prepare

	sed \
		-e "/import/s: python : ${PYTHON} :g" \
		-i configure.ac || die

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		--with-session-bus-services-dir="${EPREFIX}/usr/share/dbus-1/services"
		$(use_enable sql-debug explain-queries)
		$(use_enable datahub)
		$(use_enable downloads-monitor)
		$(use_enable telepathy)
		$(use_enable introspection)
		$(use_with icu dee-icu)
	)

	use nls || myeconfargs+=( --disable-nls )
	use fts && myeconfargs+=( --enable-fts )
	autotools-utils_src_configure
}

src_install() {
	dobashcomp data/completions/zeitgeist-daemon
	autotools-utils_src_install
	cd python || die
	python_moduleinto ${PN}
	python_foreach_impl python_domodule *py
}
