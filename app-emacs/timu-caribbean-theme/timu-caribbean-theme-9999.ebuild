# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Color theme with cyan as a dominant color"
HOMEPAGE="https://gitlab.com/aimebertrand/timu-caribbean-theme"

if [[ "${PV}" = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/aimebertrand/${PN}.git"
else
	SRC_URI="https://gitlab.com/aimebertrand/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
	S="${WORKDIR}/${PN}-v${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

SITEFILE="50${PN}-gentoo.el"
