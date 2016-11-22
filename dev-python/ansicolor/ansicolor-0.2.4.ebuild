# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Produce ansi color output and colored highlighting and diffing"
HOMEPAGE="https://github.com/numerodix/ansicolor"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	https://github.com/numerodix/ansicolor/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""
