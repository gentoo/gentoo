# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 meson

DESCRIPTION="Small tools to aid with Gentoo development, primarily intended for QA"
HOMEPAGE="https://github.com/ionenwks/iwdevtools"
EGIT_REPO_URI="https://github.com/ionenwks/iwdevtools.git"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""

RDEPEND="
	app-portage/portage-utils
	sys-apps/diffutils
	sys-apps/portage
	sys-apps/file
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
