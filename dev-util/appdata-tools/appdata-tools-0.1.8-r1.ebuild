# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="CLI designed to validate AppData descriptions for standards compliance and to the style guide"
HOMEPAGE="https://github.com/hughsie/appdata-tools/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ppc ppc64 sparc x86"
IUSE=""

# Superseeded by appstream-glib.
RDEPEND=">=dev-libs/appstream-glib-0.3.2"
