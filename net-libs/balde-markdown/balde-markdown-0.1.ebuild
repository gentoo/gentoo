# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/balde-markdown/balde-markdown-0.1.ebuild,v 1.3 2014/08/10 20:48:06 slyfox Exp $

EAPI=5

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://github.com/balde/balde-markdown.git
		https://github.com/balde/balde-markdown.git"
	inherit git-r3 autotools
fi

DESCRIPTION="A balde extension that adds Markdown support"
HOMEPAGE="https://github.com/balde/balde-markdown"

SRC_URI="https://github.com/balde/${PN}/releases/download/v${PV}/${P}.tar.bz2"
KEYWORDS="~amd64 ~x86"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
fi

LICENSE="LGPL-2"
SLOT="0"
IUSE="test"

RDEPEND=">=dev-libs/glib-2.34
	>=net-libs/balde-0.1
	app-text/discount"

DEPEND="${RDEPEND}"

src_prepare() {
	[[ ${PV} = *9999* ]] && eautoreconf
	default
}

src_configure() {
	econf \
		--without-valgrind
}
