# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/skkserv/skkserv-0.ebuild,v 1.3 2014/01/13 06:15:10 mrueg Exp $

EAPI=3

DESCRIPTION="Virtual for SKK server"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=""
RDEPEND="|| ( app-i18n/skkserv
		app-i18n/mecab-skkserv
		app-i18n/multiskkserv )"
