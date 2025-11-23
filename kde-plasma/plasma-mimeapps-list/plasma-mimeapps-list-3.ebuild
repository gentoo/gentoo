# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Gentoo curated mimeapps list for KDE Plasma"
HOMEPAGE="https://specifications.freedesktop.org/mime-apps-spec/mime-apps-spec-1.0.1.html"
SRC_URI=""
S=${WORKDIR}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

# 6.2.4 and 6.2.5 both modified with a new revision to stop installing kde-mimeapps.list.
RDEPEND="
	!<kde-plasma/plasma-desktop-6.2.4-r1
	!=kde-plasma/plasma-desktop-6.2.5-r0
"

src_install() {
	default

	insinto /usr/share/applications/
	newins "${FILESDIR}"/mimeapps.list kde-mimeapps.list
}
