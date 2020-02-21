# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp readme.gentoo-r1

MY_PN="${PN}.el"
DESCRIPTION="Track and display emacs session uptimes"
HOMEPAGE="http://www.davep.org/emacs/"
SRC_URI="https://github.com/davep/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

S="${WORKDIR}/${MY_PN}-${PV}"
SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="Uptimes is not enabled as a site default. Add the following
	line to your ~/.emacs file to enable tracking of session uptimes:
	\n(require 'uptimes)"
