# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mono-env

EGIT_COMMIT="e31cb702937a0adcc853250a0989c5f43565f9b8"

DESCRIPTION="Visual Basic Compiler and Runtime"
HOMEPAGE="https://www.mono-project.com/docs/about-mono/languages/visualbasic/"
SRC_URI="https://github.com/mono/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 x86"
LICENSE="LGPL-2 MIT"
SLOT="0"

RDEPEND="dev-lang/mono"
DEPEND="${RDEPEND}"

# See https://github.com/mono/mono-basic/issues/49
RESTRICT="test"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
