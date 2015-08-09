# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="git://github.com/MediaCrush/MediaCrush-cli.git"
	SRC_URI=""
	KEYWORDS=""
	inherit git-r3
else
	SRC_URI="https://github.com/MediaCrush/MediaCrush-cli/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/MediaCrush-cli-${PV}"
fi

DESCRIPTION="A bash script for working with MediaCrush from a shell"
HOMEPAGE="https://github.com/MediaCrush/MediaCrush-cli"

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	app-text/asciidoc
"
RDEPEND="
	net-misc/curl
	sys-apps/file
	sys-apps/sed
"

src_compile() {
	a2x --doctype manpage --format manpage mediacrush.1.txt
}

src_install() {
	dobin mediacrush
	doman mediacrush.1

	if ! has_version x11-misc/xdg-utils; then
		einfo "Install x11-misc/xdg-utils to enable '--open' argument"
	fi
}
