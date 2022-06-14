# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.4

inherit elisp

DESCRIPTION="Emacs Lisp Development Tool"
HOMEPAGE="https://github.com/doublep/eldev/"
SRC_URI="https://github.com/doublep/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DOCS=( README.adoc )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	ELDEV_LOCAL="${S}" ./bin/${PN} test
}

src_install() {
	elisp_src_install
	dobin bin/${PN}

	# NOTICE: If ELDEV_LOCAL is defined Eldev will use it
	# to load up it's components,
	# if it is not it will bootstrap itself from network
	# always check if it uses installed Emacs Lisp files.
	# Also, do not forget to run `env-update` & reopen your shell.
	# https://github.com/doublep/eldev#influential-environment-variables
	echo "ELDEV_LOCAL=${SITELISP}/${PN}" >> "${T}"/99${PN} || die
	doenvd "${T}"/99${PN}
}

pkg_postinst() {
	elisp_pkg_postinst

	ewarn "Remember to run \`env-update && source /etc/profile\` if you plan"
	ewarn "to use Eldev in a shell before logging out (or restarting"
	ewarn "your login manager)."
}
