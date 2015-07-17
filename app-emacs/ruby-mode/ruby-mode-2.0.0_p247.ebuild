# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/ruby-mode/ruby-mode-2.0.0_p247.ebuild,v 1.8 2015/07/17 12:31:11 zlogene Exp $

EAPI=5

inherit elisp

MY_PV=${PV/_/-}
DESCRIPTION="Emacs major mode for editing Ruby code"
HOMEPAGE="http://www.ruby-lang.org/"
SRC_URI="mirror://ruby/ruby-${MY_PV}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ~ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

S="${WORKDIR}/ruby-${MY_PV}/misc"
DOCS="README"
ELISP_PATCHES="${PN}-1.9.3_p429-last-command-char.patch"
SITEFILE="50${PN}-gentoo.el"
