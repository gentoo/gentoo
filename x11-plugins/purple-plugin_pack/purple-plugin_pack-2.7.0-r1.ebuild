# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-any-r1

MY_PN=${PN/_/-}
MY_P=${MY_PN}-${PV}
DESCRIPTION="A package with many different plugins for pidgin and libpurple"
HOMEPAGE="https://bitbucket.org/rekkanoryo/purple-plugin-pack/"
SRC_URI="https://bitbucket.org/rekkanoryo/${MY_PN}/downloads/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE="debug gtk ncurses spell talkfilters"

RDEPEND="
	dev-libs/json-glib
	net-im/pidgin[gtk?,ncurses?]
	talkfilters? ( app-text/talkfilters )
	spell? ( app-text/gtkspell:2 )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	sed -e '/CFLAGS=/{s| -g3||}' -i configure || die
}

list_plugins_dep() {
	local dependency=${1}
	grep -EH "depends.*$dependency" */plugins.cfg | sed 's:/.*::'
}

src_configure() {
	local plugins=""

	# list all plugins, then pull DISABLED_PLUGINS with the ones we don't need
	plugins="$(${EPYTHON} plugin_pack.py -d dist_dirs)"
	einfo "List of all possible plugins:"
	einfo "${plugins}"

	eval DISABLED_PLUGINS="\$${PN//[^a-z]/_}_DISABLED_PLUGINS"
	# disable known broken plugins
	DISABLED_PLUGINS+=" schedule findip xmmsremote"
	use gtk || DISABLED_PLUGINS+=" $(list_plugins_dep pidgin)"
	use ncurses || DISABLED_PLUGINS+=" $(list_plugins_dep finch)"
	use spell || DISABLED_PLUGINS+=" $(list_plugins_dep gtkspell)"
	use talkfilters || DISABLED_PLUGINS+=" $(list_plugins_dep talkfiltersbin)"

	for plug in ${DISABLED_PLUGINS}; do
		plugins="${plugins//${plug}}"
	done

	plugins="$(echo ${plugins} | sed 's:[ \t]\+:,:g;s:,$::;s:^,::')"

	econf \
		--with-plugins="${plugins}" \
		$(use_enable debug)
}

pkg_preinst() {
	elog "Note: if you want to disable some plugins in pack, define"
	elog "${PN//[^a-z]/_}_DISABLED_PLUGINS with a list of plugins to"
	elog "skip during install (for list see einfo in build output)."
}
