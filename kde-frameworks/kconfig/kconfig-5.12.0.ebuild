# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/kconfig/kconfig-5.12.0.ebuild,v 1.1 2015/07/16 20:33:13 johu Exp $

EAPI=5

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework for reading and writing configuration"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	dev-qt/qtgui:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}
	nls? ( dev-qt/linguist-tools:5 )
	test? ( dev-qt/qtconcurrent:5 )
"

DOCS=( DESIGN docs/DESIGN.kconfig docs/options.md )
