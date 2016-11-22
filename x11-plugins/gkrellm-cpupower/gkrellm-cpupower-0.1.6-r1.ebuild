# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gkrellm-plugin

MY_P=${P/gkrellm/gkrellm2}

DESCRIPTION="A Gkrellm2 plugin for displaying and manipulating CPU frequency"
HOMEPAGE="https://github.com/sainsaar/gkrellm2-cpupower/"
SRC_URI="https://github.com/sainsaar/gkrellm2-cpupower/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

# Collision with /usr/sbin/cpufreqnextgovernor
RDEPEND="app-admin/sudo
	sys-power/cpupower
	!x11-plugins/gkrellm-cpufreq"

PLUGIN_SO="cpupower.so"

src_install() {
	gkrellm-plugin_src_install
	dosbin cpufreqnextgovernor
	emake DESTDIR="${D}" install-sudo
}

pkg_postinst() {
	echo
	einfo "For changing the governor and CPU frequencies as a user, create the \"trusted\""
	einfo "group, and add those users to that group who should be allowed to perform"
	einfo "these changes."
	echo
}
