# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="PHP implementation of JSON schema"
HOMEPAGE="https://github.com/justinrainbow/json-schema"
SRC_URI="https://github.com/justinrainbow/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"

src_install() {
	insinto "/usr/share/php/JsonSchema"
	doins -r src/JsonSchema/. "${FILESDIR}"/autoload.php
	dodoc README.md
}
