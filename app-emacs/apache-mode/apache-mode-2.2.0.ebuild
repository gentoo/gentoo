# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Major mode for editing Apache configuration files"
HOMEPAGE="https://github.com/emacs-php/apache-mode"
SRC_URI="https://github.com/emacs-php/apache-mode/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

SITEFILE="50${PN}-gentoo.el"
DOCS="README.org"
