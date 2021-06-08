# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp readme.gentoo-r1

DESCRIPTION="Emacs modes for editing ebuilds and other Gentoo specific files"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Emacs"
SRC_URI="https://dev.gentoo.org/~ulm/emacs/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

BDEPEND="sys-apps/texinfo"

DOCS="ChangeLog keyword-generation.sh"
ELISP_TEXINFO="${PN}.texi"
SITEFILE="50${PN}-gentoo-1.51.el"
DOC_CONTENTS="Some optional features may require installation of additional
	packages, like dev-python/docutils-glep for glep."
