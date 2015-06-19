# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kdirstat/kdirstat-2.7.5.ebuild,v 1.6 2015/06/04 18:57:33 kensington Exp $

EAPI=5

KDE_LINGUAS="de fr hu it ja"
inherit kde4-base

DESCRIPTION="Nice KDE replacement to the du command"
HOMEPAGE="https://bitbucket.org/jeromerobert/k4dirstat/"
SRC_URI="https://bitbucket.org/jeromerobert/k4dirstat/get/k4dirstat-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="$(add_kdeapps_dep libkonq)
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS CREDITS TODO )

src_unpack() {
	# tarball contains git revision hash, which we don't want in the ebuild.
	default
	mv "${WORKDIR}"/*k4dirstat-* "${S}" || die
}
