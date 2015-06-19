# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/yaml-mode/yaml-mode-0.0.9.ebuild,v 1.2 2014/04/11 17:32:49 bicatali Exp $

EAPI=5

inherit elisp

DESCRIPTION="A major mode for GNU Emacs for editing YAML files"
HOMEPAGE="https://github.com/yoshiki/yaml-mode"
SRC_URI="https://github.com/yoshiki/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}/${PN}-release-${PV}"
DOCS="README Changes"
SITEFILE="50${PN}-gentoo.el"
