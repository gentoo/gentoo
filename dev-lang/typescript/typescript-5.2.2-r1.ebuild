# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit nodejs-pack

DESCRIPTION="Superset of JavaScript with optional static typing, classes and interfaces"
HOMEPAGE="https://www.typescriptlang.org/
	https://github.com/microsoft/TypeScript/"
SRC_URI="https://registry.npmjs.org/${PN}/-/${P}.tgz"
S="${WORKDIR}"/package

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64"
