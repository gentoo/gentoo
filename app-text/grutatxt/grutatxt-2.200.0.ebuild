# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_NAME="Grutatxt"
DIST_VERSION="2.20"

inherit perl-module

DESCRIPTION="A converter from plain text to HTML and other markup languages"
HOMEPAGE="https://triptico.com/software/grutatxt.html"
# upstream no longer versions the tarballs
SRC_URI="https://triptico.com/download/${PN}.tar.gz -> ${P}.tar.gz"
LICENSE="public-domain"

SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 ~sparc x86"
