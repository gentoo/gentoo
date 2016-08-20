# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit rebar

DESCRIPTION="Riak Protocol Buffers messages"
HOMEPAGE="https://github.com/basho/riak_pb"
SRC_URI="https://github.com/basho/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ~sparc x86"

DEPEND=">=dev-erlang/protobuffs-0.8.2
	>=dev-lang/erlang-17.1"
RDEPEND="${DEPEND}"

DOCS=( README.md )
