# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/appdata-tools/appdata-tools-0.1.8-r1.ebuild,v 1.11 2015/06/07 10:25:28 maekke Exp $

EAPI=5

DESCRIPTION="CLI designed to validate AppData descriptions for standards compliance and to the style guide"
HOMEPAGE="https://github.com/hughsie/appdata-tools/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="amd64 arm hppa ~ia64 ppc ppc64 x86"
IUSE=""

# Superseeded by appstream-glib.
RDEPEND=">=dev-libs/appstream-glib-0.3.2"
