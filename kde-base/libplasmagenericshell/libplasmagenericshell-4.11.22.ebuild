# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DECLARATIVE_REQUIRED="always"
KMNAME="kde-workspace"
KMMODULE="libs/plasmagenericshell"
inherit kde4-meta

DESCRIPTION="Libraries for the KDE Plasma shell"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug test"

DEPEND="
	kde-plasma/kephal:4
	kde-plasma/libkworkspace:4
	x11-libs/libX11
"
RDEPEND="${DEPEND}"

KMSAVELIBS="true"

KMEXTRACTONLY="
	libs/kephal/kephal/
	plasma/desktop/shell/data/
"
