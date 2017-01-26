# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kde-workspace"
KMMODULE="libs/taskmanager"
inherit kde4-meta

DESCRIPTION="A library that provides basic taskmanager functionality"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	kde-frameworks/kactivities:4
	kde-plasma/kephal:4
	kde-plasma/ksysguard:4
	kde-plasma/libkworkspace:4
	x11-libs/libX11
"
RDEPEND="${DEPEND}"

KMSAVELIBS="true"

KMEXTRACTONLY="
	libs/kephal/
	libs/kworkspace/
"

src_prepare() {
	kde4-meta_src_prepare
	sed -e 's:ksysguard/processcore/processes.h:ksysguard/processes.h:g' -i "${S}/libs/taskmanager/taskitem.cpp" || die
	sed -e 's:ksysguard/processcore/process.h:ksysguard/process.h:g' -i "${S}/libs/taskmanager/taskitem.cpp" || die
}
