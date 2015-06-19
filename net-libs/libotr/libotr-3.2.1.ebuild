# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libotr/libotr-3.2.1.ebuild,v 1.9 2014/03/01 22:31:38 mgorny Exp $

EAPI=5

DESCRIPTION="(OTR) Messaging allows you to have private conversations over instant messaging"
HOMEPAGE="https://otr.cypherpunks.ca"
SRC_URI="http://www.cypherpunks.ca/otr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x86-macos"

RDEPEND=">=dev-libs/libgcrypt-1.2:0
	dev-libs/libgpg-error"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README UPGRADING )
