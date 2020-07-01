# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

MY_PV="${PV//_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="vim plugin: Support EditorConfig files "
HOMEPAGE="https://editorconfig.org/"
SRC_URI="https://github.com/${PN%-vim}/${PN}/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2 PSF-2"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN%-vim}.txt"

src_prepare() {
	default

	rm LICENSE LICENSE.PSF \
		mkzip.sh .editorconfig \
		.git{ignore,modules} \
		.{travis,appveyor}.yml || die
}

src_install() {
	# we don't want to install the tests
	rm -r tests || die

	vim-plugin_src_install
}
