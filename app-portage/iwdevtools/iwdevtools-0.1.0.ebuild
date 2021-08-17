# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Small tools to aid with Gentoo development, primarily intended for QA"
HOMEPAGE="https://github.com/ionenwks/iwdevtools"
SRC_URI="https://github.com/ionenwks/iwdevtools/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-portage/portage-utils
	sys-apps/diffutils
	sys-apps/file
	sys-apps/portage
	sys-apps/util-linux"

src_configure() {
	meson_src_configure -Ddocdir=${PF}
}

pkg_postinst() {
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "To (optionally) integrate with portage, inspect the .bashrc files installed"
		elog "at ${EROOT}/usr/share/${PN}. If not already using a bashrc, you can use"
		elog "the example bashrc directly by creating a symlink:"
		elog
		elog "    ln -s ../../../usr/share/${PN}/bashrc ${EROOT}/etc/portage/bashrc"
		elog
	fi
}
