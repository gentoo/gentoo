# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib eutils qt4-r2

MY_P="qxmledit-${PV}-src"

DESCRIPTION="Qt4 XML Editor"
HOMEPAGE="http://code.google.com/p/qxmledit/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.tgz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND=">=dev-qt/qtcore-4.7:4
	>=dev-qt/qtgui-4.7:4
	>=dev-qt/qtsql-4.7:4
	>=dev-qt/qtsvg-4.7:4
	>=dev-qt/qtxmlpatterns-4.7:4"
RDEPEND="${DEPEND}"

DOCS="AUTHORS NEWS README ROADMAP TODO"

src_prepare() {
	# fix doc dir
	sed -i "/INST_DOC_DIR = / s|/opt/${PN}|/usr/share/doc/${PF}|" \
		src/QXmlEdit{,Widget}.pro src/sessions/QXmlEditSessions.pro || \
		die "failed to fix doc installation path"
	# fix binary installation path
	sed -i "/INST_DIR = / s|/opt/${PN}|/usr/bin|" \
		src/QXmlEdit{,Widget}.pro src/sessions/QXmlEditSessions.pro || \
		die "failed to fix binary installation path"
	# fix helper libraries installation path
	sed -i "/INST_LIB_DIR = / s|/opt/${PN}|/usr/$(get_libdir)|" \
		src/QXmlEdit{,Widget}.pro \
		src/sessions/QXmlEditSessions.pro || \
		die "failed to fix library installation path"
	# fix translations
	sed -i "/INST_DATA_DIR = / s|/opt|/usr/share|" src/QXmlEdit{,Widget}.pro \
		src/sessions/QXmlEditSessions.pro || \
		die "failed to fix translations"
	# fix include
	sed -i "/INST_INCLUDE_DIR = / s|/opt|/usr/share|" src/QXmlEditWidget.pro \
		|| die "failed to fix include directory"

	qt4-r2_src_prepare
}

src_install() {
	qt4-r2_src_install

	newicon src/images/icon.png ${PN}.png
	make_desktop_entry QXmlEdit QXmlEdit ${PN} "Qt;Utility;TextEditor"
}
