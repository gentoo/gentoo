# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.3

inherit elisp

DESCRIPTION="An Emacs mode that alternates the background color of lines"
HOMEPAGE="https://www.emacswiki.org/emacs/StripesMode
	https://gitlab.com/stepnem/stripes-el/"
SRC_URI="https://gitlab.com/stepnem/${PN}-el/-/archive/${PV}/${PN}-el-${PV}.tar.bz2"
S="${WORKDIR}"/${PN}-el-${PV}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 x86"

SITEFILE="50${PN}-gentoo.el"
