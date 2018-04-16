# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mono-env

DESCRIPTION="Visual Basic Compiler and Runtime"
HOMEPAGE="https://www.mono-project.com/docs/about-mono/languages/visualbasic/"

KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2 MIT"
SLOT="0"

RDEPEND="dev-lang/mono"
DEPEND="${RDEPEND}"
