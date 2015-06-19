# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/eselect-mode/eselect-mode-1.4.4.ebuild,v 1.10 2015/04/14 10:50:54 ago Exp $

EAPI=5

inherit elisp

MY_P="eselect-${PV}"
DESCRIPTION="Emacs major mode for editing eselect files"
HOMEPAGE="http://wiki.gentoo.org/wiki/Project:Eselect"
SRC_URI="http://dev.gentoo.org/~ulm/eselect/${MY_P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

S="${WORKDIR}/${MY_P}/misc"
SITEFILE="50${PN}-gentoo.el"
