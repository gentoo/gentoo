# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="A Helm interface to the package manager of your operating system"
HOMEPAGE="https://github.com/emacs-helm/helm-system-packages"
SRC_URI="https://github.com/emacs-helm/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-emacs/helm"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"
DOCS="readme.org"
