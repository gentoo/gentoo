# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Collection of rpm packaging related utilities"
HOMEPAGE="https://fedorahosted.org/rpmdevtools/"
SRC_URI="https://fedorahosted.org/releases/r/p/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="emacs"

CDEPEND="
	app-arch/rpm[python]
	net-misc/curl
	emacs? ( app-emacs/rpm-spec-mode )
	dev-util/checkbashisms
"

DEPEND="
	${CDEPEND}
	dev-lang/perl
	sys-apps/help2man
"

RDEPEND="${CDEPEND}"

src_install() {
	default

	rm "${ED}/usr/bin/checkbashisms" || die "Failed to remove checkbashisms script"
}
