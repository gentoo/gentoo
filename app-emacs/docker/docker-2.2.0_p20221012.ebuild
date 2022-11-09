# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=3173403a2d51a2af36f7fdb0b7d2bec9e202e772
NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Emacs integration for Docker"
HOMEPAGE="https://github.com/Silex/docker.el/"
SRC_URI="https://github.com/Silex/${PN}.el/archive/${H}.tar.gz
	-> ${PN}.el-${PV}.tar.gz"
S="${WORKDIR}"/${PN}.el-${H}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=app-emacs/transient-0.3.7_p20220918
	app-emacs/dash
	app-emacs/docker-tramp
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
