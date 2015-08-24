# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

PYTHON_DEPEND="2"
PYTHON_USE_WITH=sqlite

inherit eutils versionator python multilib

ARTWORK_PV="0.9.4"

DESCRIPTION="Movie collection manager"
HOMEPAGE="http://www.griffith.cc/"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz
	https://dev.gentoo.org/~hwoarang/distfiles/${PN}-extra-artwork-${ARTWORK_PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE="doc"

RDEPEND="virtual/python-imaging
	gnome-base/libglade
	dev-python/pyxml
	>=dev-python/pygtk-2.6.1:2
	dev-python/pygobject:2
	>=dev-python/sqlalchemy-0.5.2
	>=dev-python/reportlab-1.19"
DEPEND="${RDEPEND}
	doc? ( app-text/docbook2X )"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed -i \
		-e 's#/pl/#/pl.UTF-8/#' \
		"${S}"/docs/pl/Makefile || die "sed failed"

	sed -i \
		-e 's/ISO-8859-1/UTF-8/' \
		"${S}"/lib/gconsole.py || die "sed failed"
	epatch "${FILESDIR}/0.10-fix_lib_path.patch"
}

src_compile() {
	# Nothing to compile and default `emake` spews an error message
	true
}

src_install() {
	use doc || { sed -i -e '/docs/d' Makefile || die ; }

	emake \
		LIBDIR="${D}/usr/$(get_libdir)/griffith" \
		DESTDIR="${D}" DOC2MAN=docbook2man.pl install
	dodoc AUTHORS ChangeLog README THANKS TODO NEWS TRANSLATORS

	cd "${WORKDIR}/${PN}-extra-artwork-${ARTWORK_PV}/"
	emake DESTDIR="${D}" install
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/${PN}
	einfo
	einfo "${PN} can make use of the following optional dependencies"
	einfo "dev-python/chardet: CSV file encoding detections"
	einfo "dev-python/mysql-python: Python interface for MySQL connectivity"
	einfo ">=dev-python/psycopg-2.4: Python interface for PostgreSQL connectivity"
	einfo
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/${PN}
}
