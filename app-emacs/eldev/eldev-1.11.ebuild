# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo elisp

DESCRIPTION="Emacs Lisp Development Tool"
HOMEPAGE="https://emacs-eldev.github.io/eldev/
	https://github.com/emacs-eldev/eldev/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/doublep/${PN}.git"
else
	SRC_URI="https://github.com/emacs-eldev/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="amd64 ~arm ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

ELISP_REMOVE="
	test/doctor.el
"

DOCS=( README.adoc )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	local -x ELDEV_LOCAL="${S}"

	edo "./bin/${PN}" test
}

src_install() {
	elisp_src_install

	exeinto /usr/bin
	doexe "./bin/${PN}"

	# NOTICE: If ELDEV_LOCAL is defined Eldev will use it
	# to load up it's components,
	# if it is not it will bootstrap itself from network
	# always check if it uses installed Emacs Lisp files.
	# Also, do not forget to run `env-update` & reopen your shell.
	# https://github.com/doublep/eldev#influential-environment-variables
	echo "ELDEV_LOCAL=${SITELISP}/${PN}" >> "${T}/99${PN}" || die
	doenvd "${T}/99${PN}"
}

pkg_postinst() {
	elisp_pkg_postinst

	ewarn "Remember to run \`env-update && source /etc/profile\` if you plan"
	ewarn "to use Eldev in a shell before logging out (or restarting"
	ewarn "your login manager)."
}
