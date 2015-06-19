# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/emacs-flim/emacs-flim-0.ebuild,v 1.2 2012/10/17 07:00:13 ulm Exp $

EAPI=4

DESCRIPTION="Virtual for FLIM (library for message representation in Emacs)"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"

RDEPEND="|| (
		app-emacs/flim
		app-emacs/limit
	)"
