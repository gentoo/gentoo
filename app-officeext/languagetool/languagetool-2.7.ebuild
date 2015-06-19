# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-officeext/languagetool/languagetool-2.7.ebuild,v 1.1 2014/12/28 22:16:55 dilfridge Exp $

EAPI=5

MY_P="LanguageTool-${PV}"

OFFICE_REQ_USE="java"

OFFICE_EXTENSIONS=(
	"${MY_P}.oxt"
)

inherit office-ext-r1

DESCRIPTION="Style and Grammar Checker for libreoffice"
HOMEPAGE="http://www.languagetool.org/"
SRC_URI="http://www.languagetool.org/download/${MY_P}.oxt"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jdk-1.7"
