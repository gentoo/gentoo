# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ "${PV}" = 1.4.3 ]] && COMMIT="468ac1ab50d7e0feae2c06f12596bbc169f2abe4"

NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Pop up a frame at point"
HOMEPAGE="https://github.com/tumashu/posframe/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/tumashu/${PN}.git"
else
	SRC_URI="https://github.com/tumashu/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.org snapshots )
SITEFILE="50${PN}-gentoo.el"
