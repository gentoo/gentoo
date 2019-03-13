# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MY_P="${P^g}"

DESCRIPTION="MeCab binding for Gauche"
HOMEPAGE="https://github.com/shirok/Gauche-mecab"
SRC_URI="https://github.com/shirok/${PN^g}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-text/mecab
	>=dev-scheme/gauche-0.9.5"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"
