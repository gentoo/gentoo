# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

COMMIT="9e9c37d2a54771c635d00d1fe171cef5eab4d95d"
DESCRIPTION="Minibuffer input completion and cycling"
HOMEPAGE="https://www.emacswiki.org/emacs/Icicles"
# Snapshot of https://github.com/emacsmirror/icicles.git
# PV is <Version>.<Update #> from header of icicles.el
SRC_URI="https://github.com/emacsmirror/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}"/${P}-emacs-28.patch )
SITEFILE="50${PN}-gentoo.el"
