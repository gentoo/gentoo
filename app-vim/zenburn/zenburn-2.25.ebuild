# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

MY_PN="Zenburn"

DESCRIPTION="Low-contrast color scheme for Vim"
HOMEPAGE="https://github.com/jnurmine/Zenburn"
SRC_URI="https://github.com/jnurmine/${MY_PN}/archive/v${PV}.zip -> ${P}.zip"
LICENSE="GPL-1"
KEYWORDS="amd64 ppc ppc64 x86"

DEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_PN}-${PV}"
