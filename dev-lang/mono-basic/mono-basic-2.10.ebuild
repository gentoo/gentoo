# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/mono-basic/mono-basic-2.10.ebuild,v 1.4 2011/05/11 19:28:54 angelos Exp $

EAPI=2

inherit go-mono mono multilib

DESCRIPTION="Visual Basic .NET Runtime and Class Libraries"
HOMEPAGE="http://www.mono-project.com/VisualBasic.NET_support"

LICENSE="LGPL-2 MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RESTRICT="test"
