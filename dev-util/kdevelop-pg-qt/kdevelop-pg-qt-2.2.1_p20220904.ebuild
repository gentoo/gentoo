# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KDE_ORG_CATEGORY="kdevelop"
KDE_ORG_COMMIT="72138ed04d427f520e65b146525632e967177abe"
inherit ecm kde.org

DESCRIPTION="LL(1) parser generator used mainly by KDevelop language plugins"
HOMEPAGE="https://kdevelop.org/"

LICENSE="LGPL-2+ LGPL-2.1+"
SLOT="5"
KEYWORDS="amd64 ~arm64 ~ppc64 ~x86"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
"
