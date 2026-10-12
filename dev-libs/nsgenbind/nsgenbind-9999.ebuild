# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit git-r3 netsurf

DESCRIPTION="Generate Javascript-to-DOM bindings from w3c webidl files"
HOMEPAGE="https://www.netsurf-browser.org/"
EGIT_REPO_URI="git://git.netsurf-browser.org/${PN}.git"

LICENSE="MIT"
SLOT="0/${PV}"

BDEPEND="
	dev-build/netsurf-buildsystem
	app-alternatives/yacc"

_emake() {
	netsurf_define_makeconf
	emake "${NETSURF_MAKECONF[@]}" COMPONENT_TYPE=binary $@
}

src_compile() {
	_emake
}

src_install() {
	_emake DESTDIR="${D}" install
}

src_test() {
	# Note: tests currently "pass" due to the test runner not
	# failing on errors:
	#
	#  https://bugs.netsurf-browser.org/mantis/view.php?id=2926
	#
	_emake test
}
