# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="GNU Emacs mode for editing and running PowerShell code"
HOMEPAGE="https://github.com/jschaf/powershell.el/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jschaf/${PN}.el.git"
else
	if [[ ${PV} == *_pre20220805 ]] ; then
		COMMIT=f2da15857e430206e215a3c65289b4058ae3c976
		SRC_URI="https://github.com/jschaf/${PN}.el/archive/${COMMIT}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}"/${PN}.el-${COMMIT}
	else
		SRC_URI="https://github.com/jschaf/${PN}.el/archive/${PV}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}"/${PN}.el-${PV}
	fi
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
