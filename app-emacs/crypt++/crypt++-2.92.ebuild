# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/crypt++/crypt++-2.92.ebuild,v 1.9 2015/02/25 06:49:31 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Handle all sorts of compressed and encrypted files"
HOMEPAGE="http://www.emacswiki.org/emacs/CryptPlusPlus"
SRC_URI="mirror://debian/pool/main/c/crypt++el/crypt++el_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

S="${WORKDIR}/${PN}el-${PV}"
SITEFILE="50${PN}-gentoo.el"
