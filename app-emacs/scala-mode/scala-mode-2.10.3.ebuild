# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/scala-mode/scala-mode-2.10.3.ebuild,v 1.4 2015/05/27 11:18:47 ago Exp $

EAPI=5

inherit elisp

MY_P="scala-tool-support-${PV}"
DESCRIPTION="Scala mode for Emacs"
HOMEPAGE="http://www.scala-lang.org/"
SRC_URI="http://www.scala-lang.org/files/archive/${MY_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-lang/scala"

S="${WORKDIR}/${MY_P}/scala-emacs-mode"
SITEFILE="50${PN}-gentoo.el"
DOCS="AUTHORS FUTURE README"
