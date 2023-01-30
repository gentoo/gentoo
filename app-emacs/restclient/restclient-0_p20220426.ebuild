# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=ae79e7dd283890072da69b8f48aeec1afd0d9442
NEED_EMACS=24.4

inherit elisp

DESCRIPTION="HTTP REST client tool for GNU Emacs"
HOMEPAGE="https://github.com/pashky/restclient.el/"
SRC_URI="https://github.com/pashky/${PN}.el/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}.el-${COMMIT}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	app-emacs/helm
	app-emacs/jq-mode
"
BDEPEND="${RDEPEND}"

DOCS=( README.md examples )
SITEFILE="50${PN}-gentoo.el"
