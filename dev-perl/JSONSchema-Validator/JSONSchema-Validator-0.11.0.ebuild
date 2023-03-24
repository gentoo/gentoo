# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="PUTINTSEV"
DIST_VERSION="0.011"

inherit perl-module

DESCRIPTION="Validator for JSON Schema Draft4/Draft6/Draft7 and OpenAPI Specification 3.0"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-perl/URI-5.100.0"

BDEPEND="${RDEPEND}"
