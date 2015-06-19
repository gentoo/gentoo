# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/rpmdevtools/rpmdevtools-8.3.ebuild,v 1.1 2012/12/04 08:35:41 scarabeus Exp $

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
