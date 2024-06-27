# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Gentoo curated mimeapps list for KDE Plasma"
HOMEPAGE="https://specifications.freedesktop.org/mime-apps-spec/mime-apps-spec-1.0.1.html"
SRC_URI=""
S=${WORKDIR}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

RDEPEND=""

src_install() {
	default

	# TODO: Should we just remove the upstream one in /usr/share?
	# /etc/xdg should really be available for site-local overrides, but then
	# again we have CONFIG_PROTECT...
	insinto /etc/xdg/mimeapps.list
	doins "${FILESDIR}"/mimeapps.list
}
