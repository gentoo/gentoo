# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KDE_ORG_CATEGORY="kdevelop"
KDE_ORG_COMMIT="e80d3b24307de656fdaefa08f258d61a4408c78d"
KFMIN=5.92.0
inherit ecm kde.org

DESCRIPTION="LL(1) parser generator used mainly by KDevelop language plugins"
HOMEPAGE="https://www.kdevelop.org/"

LICENSE="LGPL-2+ LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
"
