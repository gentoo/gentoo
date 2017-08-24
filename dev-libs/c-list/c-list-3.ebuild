# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

DESCRIPTION="Circular Double Linked List Implementation in Standard ISO-C11"
HOMEPAGE="https://github.com/c-util/c-list"
SRC_URI="https://github.com/c-util/c-list/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
