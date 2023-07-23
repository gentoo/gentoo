# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Emacs integration for Docker"
HOMEPAGE="https://github.com/Silex/docker.el/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Silex/${PN}.el.git"
else
	[[ ${PV} == *_p20230605 ]] && COMMIT=df141addfec256cfb943fa1823b4b2ad8f461fa9
	SRC_URI="https://github.com/Silex/${PN}.el/archive/${COMMIT}.tar.gz
		-> ${PN}.el-${PV}.tar.gz"
	S="${WORKDIR}"/${PN}.el-${COMMIT}
	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/transient-0.3.7_p20220918
	app-emacs/dash
	app-emacs/emacs-aio
	app-emacs/s
	app-emacs/tablist
"
BDEPEND="${RDEPEND}"

DOCS=( CHANGELOG.md README.md screenshots )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
