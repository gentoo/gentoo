# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no" # We skip gnome2_src_configure entirely
PYTHON_COMPAT=( python2_7 )

inherit eutils gnome2 python-single-r1 readme.gentoo

DESCRIPTION="OpenDict is a free cross-platform dictionary program"
HOMEPAGE="http://opendict.sourceforge.net/"
SRC_URI="http://opendict.idiles.com/files/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/wxpython:2.8[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="If you want system-wide plugins, unzip them into
${ROOT}usr/share/${PN}/dictionaries/plugins

Some are available from http://opendict.sourceforge.net/?cid=3"

src_prepare() {
	epatch "${FILESDIR}"/${P}-pyxml.patch

	sed -e "s:), '..')):), '../../../../..', 'share', 'opendict')):g" \
		-i "${S}/lib/info.py"

	gnome2_src_prepare
}

src_configure() {
	# override gnome2_src_configure
	default
}

src_compile() {
	# evil makefile
	:
}

src_install() {
	# makefile is broken, do it manually

	dodir /usr/share/${PN}/dictionaries/plugins # global dictionary plugins folder

	# Needed by GUI
	insinto /usr/share/${PN}
	doins "${S}"/copying.html

	insinto /usr/share/${PN}/pixmaps
	doins "${S}"/pixmaps/*

	DHOME="$(python_get_sitedir)/opendict"
	insinto "${DHOME}/lib"
	doins -r "${S}"/lib/*
	exeinto "${DHOME}"
	python_fix_shebang opendict.py
	doexe opendict.py

	dosym "${DHOME}/opendict.py" /usr/bin/opendict

	domenu misc/${PN}.desktop

	insinto /usr/share/icons/hicolor/24x24/apps/
	newins "${S}/pixmaps/icon-24x24.png" opendict.png
	insinto /usr/share/icons/hicolor/32x32/apps/
	newins "${S}/pixmaps/icon-32x32.png" opendict.png
	insinto /usr/share/icons/hicolor/48x48/apps/
	newins "${S}/pixmaps/icon-48x48.png" opendict.png
	insinto /usr/share/icons/hicolor/scalable/apps/
	newins "${S}/pixmaps/SVG/icon-rune.svg" opendict.svg

	doman opendict.1
	dodoc README.txt TODO.txt doc/Plugin-HOWTO.html

	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}
