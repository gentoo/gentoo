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
	sys-apps/util-linux"

src_configure() {
	meson_src_configure -Ddocdir=${PF}
}
