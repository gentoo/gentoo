# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/smartirc4net/smartirc4net-0.4.5.1.ebuild,v 1.5 2013/05/25 12:22:34 pacho Exp $

EAPI=5
inherit mono-env

HOMEPAGE="http://www.smuxi.org/page/Download"
SRC_URI="http://smuxi.meebey.net/jaws/data/files/${P}.tar.gz"
DESCRIPTION="Multi-threaded and thread-safe IRC library written in C#"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
LICENSE="|| ( LGPL-2.1 LGPL-3 )"

RDEPEND=">=dev-lang/mono-2.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( FEATURES TODO API_CHANGE CHANGELOG README )
