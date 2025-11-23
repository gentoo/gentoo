# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

GIT_COMMIT_ID="e09ba5519cf6db68190a2b176f0b6b442c870057"
DESCRIPTION="VDR plugin: file manager plugin for moving or renaming files in VDR"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-filebrowser"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-filebrowser/archive/${GIT_COMMIT_ID}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-filebrowser-${GIT_COMMIT_ID}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/vdr-filebrowser-0.2.3-Makefile.patch"
	"${FILESDIR}/vdr-filebrowser-0.2.3-clang.patch"
)

src_install() {
	default

	insinto	/etc/vdr/plugins/filebrowser
	doins "${FILESDIR}"/commands.conf
	doins "${FILESDIR}"/order.conf
	doins "${FILESDIR}"/othercommands.conf
	doins "${FILESDIR}"/sources.conf
}
