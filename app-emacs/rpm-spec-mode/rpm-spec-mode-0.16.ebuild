# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ "${PV}" == 0.16 ]] && COMMIT=7d06d19a31e888b932da6c8202ff2c73f42703a1

inherit elisp

DESCRIPTION="Emacs mode to ease editing of RPM spec files"
HOMEPAGE="https://www.emacswiki.org/emacs/RpmSpecMode
	https://github.com/stigbjorlykke/rpm-spec-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/stigbjorlykke/${PN}"
else
	SRC_URI="https://github.com/stigbjorlykke/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

PATCHES=( "${FILESDIR}/${PN}-0.15-emacs-28.patch" )

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
