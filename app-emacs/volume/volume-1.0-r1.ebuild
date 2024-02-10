# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Tweak your sound card volume from Emacs"
HOMEPAGE="https://github.com/dbrock/volume.el"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

# NOTE we might define the following which volume.el can work with by
# default, but volume.el can really work with anything.

# RDEPEND="|| ( media-sound/aumixer media-sound/alsa-utils )"

PATCHES=(
	"${FILESDIR}"/${P}-mode-line.patch
	"${FILESDIR}"/${P}-emacs-28.patch
)
SITEFILE="50${PN}-gentoo.el"
