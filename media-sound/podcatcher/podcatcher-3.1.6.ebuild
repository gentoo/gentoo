# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Podcast client for the command-line written in Ruby"
HOMEPAGE="http://podcatcher.rubyforge.org/"
SRC_URI="http://rubyforge.org/frs/download.php/76053/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="bittorrent"

RDEPEND=">=dev-lang/ruby-1.8.2
	bittorrent? ( dev-ruby/rubytorrent )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_install() {
	dobin bin/podcatcher
	dodoc demo/*
}
