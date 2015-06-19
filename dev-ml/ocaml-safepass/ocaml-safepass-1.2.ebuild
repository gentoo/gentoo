# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocaml-safepass/ocaml-safepass-1.2.ebuild,v 1.2 2013/03/03 14:28:02 aballier Exp $

EAPI=5

OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="A library offering facilities for the safe storage of user passwords"
HOMEPAGE="http://ocaml-safepass.forge.ocamlcore.org/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1035/${P}.tgz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

DOCS=( "README" "CHANGELOG" )
