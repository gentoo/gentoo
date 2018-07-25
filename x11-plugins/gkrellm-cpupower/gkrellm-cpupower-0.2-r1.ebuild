# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin

MY_P="${P/gkrellm/gkrellm2}"

DESCRIPTION="A Gkrellm2 plugin for displaying and manipulating CPU frequency"
HOMEPAGE="https://github.com/sainsaar/gkrellm2-cpupower/"
SRC_URI="https://github.com/sainsaar/gkrellm2-cpupower/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-admin/gkrellm:2[X]"
RDEPEND="
	${DEPEND}
	app-admin/sudo
	sys-power/cpupower"

S=${WORKDIR}/${MY_P}

src_install() {
	local PLUGIN_SO=( cpupower$(get_modname) )
	gkrellm-plugin_src_install
	emake DESTDIR="${D}" install-sudo
}

pkg_postinst() {
	einfo
	einfo "For changing the governor and CPU frequencies as a user, create the \"trusted\""
	einfo "group, and add those users to that group who should be allowed to perform"
	einfo "these changes."
	einfo
}
