# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Read and write pcap-formatted network packet traces."
HOMEPAGE="https://github.com/mirage/ocaml-pcap https://mirage.io"
SRC_URI="https://github.com/mirage/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

# Blockers taken from opam file and only relevant
# if MirageOS should enter portage.
RDEPEND="
	dev-ml/ocaml-ipaddr:=
	!dev-ml/mirage-net-socket
	!<dev-ml/mirage-0.9.2
	>=dev-ml/ocaml-cstruct-0.6.0:=[camlp4(-)]
"
DEPEND="
	test? ( dev-ml/ounit
		>=dev-ml/lwt-2.4.0 )
	${RDEPEND}
"

DOCS=( CHANGES MAINTAINERS README.md )
