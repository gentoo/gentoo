# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Collection of rpm packaging related utilities"
HOMEPAGE="https://fedorahosted.org/rpmdevtools/"
SRC_URI="https://fedorahosted.org/releases/r/p/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs"

CDEPEND="
	app-arch/rpm[python]
	net-misc/curl
	emacs? ( app-emacs/rpm-spec-mode )
"

DEPEND="
	${CDEPEND}
	dev-lang/perl
	sys-apps/help2man
"

RDEPEND="${CDEPEND}"
