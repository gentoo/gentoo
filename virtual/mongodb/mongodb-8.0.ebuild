# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for MongoDB"
SLOT="0"
KEYWORDS="amd64 ~arm64"

RDEPEND="
	|| (
		=dev-db/mongodb-bin-${PV}*
		=dev-db/mongodb-${PV}*
	)
"
