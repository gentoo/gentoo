# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp readme.gentoo-r1

DESCRIPTION="Writable grep buffer and apply the changes to files"
HOMEPAGE="https://github.com/mhayashi1120/Emacs-wgrep"
SRC_URI="https://github.com/mhayashi1120/Emacs-${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/Emacs-${P}"
SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="See commentary in ${SITELISP}/${PN}/wgrep.el for documentation.
	\n\nTo activate wgrep, add the following line to your ~/.emacs file:
	\n\t(require 'wgrep)"
