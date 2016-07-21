# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='sqlite'

inherit versionator python-single-r1 multilib

ARTWORK_PV="0.9.4"

DESCRIPTION="Movie collection manager"
HOMEPAGE="http://www.griffith.cc/"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz
	https://dev.gentoo.org/~hwoarang/distfiles/${PN}-extra-artwork-${ARTWORK_PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="doc"

RDEPEND="dev-python/pillow
	gnome-base/libglade
	dev-python/pyxml[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.6.1:2[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/reportlab-1.19[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( app-text/docbook2X )"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	use doc || { sed -i -e '/docs/d' Makefile || die ; }
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
	# This carries over from -0.13 but appears to have no effect.
	python_optimize "${D}"usr/share/${PN}
}

pkg_postinst() {
	einfo
	einfo "${PN} can make use of the following optional dependencies"
	einfo "dev-python/chardet: CSV file encoding detections"
	einfo "dev-python/mysql-python: Python interface for MySQL connectivity"
	einfo ">=dev-python/psycopg-2.4: Python interface for PostgreSQL connectivity"
	einfo
}
