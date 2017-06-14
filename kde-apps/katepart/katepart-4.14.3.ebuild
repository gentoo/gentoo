# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kate"
KMMODULE="part"
inherit kde4-meta

DESCRIPTION="Editor KPart by KDE"
HOMEPAGE+=" http://kate-editor.org/about-katepart/"
KEYWORDS="amd64 ~ppc64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug"

RESTRICT="test"
# bug 392993

KMEXTRA="
	addons/ktexteditor
"
