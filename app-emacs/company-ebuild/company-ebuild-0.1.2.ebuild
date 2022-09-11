# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.2

inherit elisp

DESCRIPTION="Company backend for editing Ebuild files"
HOMEPAGE="https://gitweb.gentoo.org/proj/company-ebuild.git"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitweb.gentoo.org/proj/${PN}.git"
else
	SRC_URI="https://gitweb.gentoo.org/proj/${PN}.git/snapshot/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~x64-macos"
fi

LICENSE="GPL-2+"
SLOT="0"

SITEFILE="50${PN}-gentoo.el"

RDEPEND="
	app-emacs/company-mode
	app-emacs/ebuild-mode
"
BDEPEND="${RDEPEND}"
