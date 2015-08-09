# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vim-plugin

MY_PN="${PN}-vim"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Rust mode for vim"
HOMEPAGE="http://www.rust-lang.org/"
SRC_URI="http://dev.gentoo.org/~jauhien/distfiles/${MY_P}.tar.gz"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${MY_P}"
