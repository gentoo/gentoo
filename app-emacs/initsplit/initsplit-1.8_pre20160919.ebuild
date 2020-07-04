# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp readme.gentoo-r1

COMMIT="c941d436eb2b10b01c76a582c5a2b23fb30751aa"
DESCRIPTION="Split customizations into different files"
HOMEPAGE="https://www.emacswiki.org/emacs/InitSplit"
SRC_URI="https://github.com/dabrahams/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

S="${WORKDIR}/${PN}-${COMMIT}"
SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="Initsplit is not enabled as a site default. Add the following
	line to your ~/.emacs file to enable configuration file splitting:
	\n\t(load \"initsplit\")
	\n\nIf you want configuration files byte-compiled, also add this line:
	\n\t(add-hook 'after-save-hook 'initsplit-byte-compile-files t)"
