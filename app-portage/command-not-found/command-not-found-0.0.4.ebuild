# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit optfeature python-r1

DESCRIPTION="Command-not-found handler for Gentoo"
HOMEPAGE="https://github.com/AndrewAmmerlaan/command-not-found-gentoo"
SRC_URI="https://github.com/AndrewAmmerlaan/command-not-found-gentoo/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-gentoo-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"

src_install() {
	python_foreach_impl python_doscript command-not-found

	insinto /etc/bash/bashrc.d
	doins command-not-found.sh

	einstalldocs
}

pkg_postinst() {
	elog "${PN} is automatically setup for app-shells/bash, see"
	elog "    /usr/share/doc/${PF}/README.md"
	elog "for instructions on how to set it up for various other shells."
	elog
	optfeature "suggesting snaps providing the missing command" "app-containers/snapd"
	optfeature "suggesting ebuilds providing the missing command" "app-portage/pfl"
}
