# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp optfeature

MY_P="scala-tool-support-${PV}"
DESCRIPTION="Scala mode for Emacs"
HOMEPAGE="https://www.scala-lang.org/"
SRC_URI="https://www.scala-lang.org/files/archive/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}/scala-emacs-mode"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

SITEFILE="50${PN}-gentoo.el"
DOCS="AUTHORS FUTURE README"

pkg_postinst() {
	elisp_pkg_postinst
	optfeature "running Scala interpreter with scala-run-scala" \
		dev-lang/scala dev-lang/scala-bin
}
