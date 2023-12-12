# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

MY_PN="Zenburn"

DESCRIPTION="vim plugin: Low-contrast color scheme for Vim"
HOMEPAGE="https://github.com/jnurmine/Zenburn"
SRC_URI="https://github.com/jnurmine/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
