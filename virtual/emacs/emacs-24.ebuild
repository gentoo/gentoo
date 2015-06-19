# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/emacs/emacs-24.ebuild,v 1.13 2014/01/16 17:48:59 vapier Exp $

EAPI=4

DESCRIPTION="Virtual for GNU Emacs"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

RDEPEND="|| ( app-editors/emacs:24
		>=app-editors/emacs-vcs-24.1 )"
