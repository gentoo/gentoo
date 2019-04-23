# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit mono-env

DESCRIPTION="Visual Basic Compiler and Runtime"
HOMEPAGE="https://www.mono-project.com/docs/about-mono/languages/visualbasic/"

KEYWORDS="amd64 x86"
LICENSE="LGPL-2 MIT"
SLOT="0"

RDEPEND="dev-lang/mono"
DEPEND="${RDEPEND}"

RESTRICT="test"
