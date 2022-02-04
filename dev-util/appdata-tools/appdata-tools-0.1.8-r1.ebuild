# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="CLI designed to validate AppData descriptions for standards and style compliance"
HOMEPAGE="https://github.com/hughsie/appdata-tools/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 sparc x86"

# Superseeded by appstream-glib.
RDEPEND=">=dev-libs/appstream-glib-0.3.2"
