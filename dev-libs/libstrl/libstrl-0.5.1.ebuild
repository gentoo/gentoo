# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libstrl/libstrl-0.5.1.ebuild,v 1.5 2013/02/09 08:30:15 binki Exp $

EAPI=4

inherit autotools-utils multilib

DESCRIPTION="Compat library for functions like strlcpy(), strlcat(), strnlen(), getline(), and asprintf()"
HOMEPAGE="http://ohnopub.net/~ohnobinki/libstrl/"
SRC_URI="ftp://mirror.ohnopub.net/mirror/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x64-macos"
IUSE="doc static-libs test"

# block various versions of opendkim for bug #454938 and bug #441790.
DEPEND="doc? ( app-doc/doxygen )
	test? ( dev-libs/check )
	!=mail-filter/opendkim-2.7.0 !=mail-filter/opendkim-2.7.1 !=mail-filter/opendkim-2.7.2"
RDEPEND="!=mail-filter/opendkim-2.7.0 !=mail-filter/opendkim-2.7.1 !=mail-filter/opendkim-2.7.2"

src_configure() {
	local myeconfargs=(
		$(use_with doc doxygen)
		$(use_with test check)
	)

	autotools-utils_src_configure
}
