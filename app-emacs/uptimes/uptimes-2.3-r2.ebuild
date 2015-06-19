# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/uptimes/uptimes-2.3-r2.ebuild,v 1.5 2014/04/20 11:19:53 ago Exp $

EAPI=5

inherit readme.gentoo elisp

DESCRIPTION="Track and display emacs session uptimes"
HOMEPAGE="http://www.davep.org/emacs/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="Uptimes is not enabled as a site default. Add the following
	line to your ~/.emacs file to enable tracking of session uptimes:
	\n(require 'uptimes)"
