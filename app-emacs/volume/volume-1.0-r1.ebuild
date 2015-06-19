# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/volume/volume-1.0-r1.ebuild,v 1.4 2015/01/17 13:39:33 ago Exp $

EAPI=5

inherit elisp

DESCRIPTION="Tweak your sound card volume from Emacs"
HOMEPAGE="https://github.com/dbrock/volume-el"
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

# NOTE we might define the following which volume.el can work with by
# default, but volume.el can really work with anything.

# RDEPEND="|| ( media-sound/aumixer media-sound/alsa-utils )"

ELISP_PATCHES="${P}-mode-line.patch"
SITEFILE="50${PN}-gentoo.el"
