# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="funyahoo-plusplus"
MY_P="${MY_PN}-${PV}"
COMMIT="fbbd9c591100aa00a0487738ec7b6acd3d924b3f"

DESCRIPTION="Yahoo! (2016) Protocol Plugin for Pidgin"
HOMEPAGE="https://github.com/EionRobb/funyahoo-plusplus"
SRC_URI="https://github.com/EionRobb/funyahoo-plusplus/archive/${COMMIT}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	net-im/pidgin
	dev-libs/json-glib
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${COMMIT}"
