# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="PaKChoiS - PKCS #11 wrapper library"
HOMEPAGE="http://www.manyfish.co.uk/pakchois/"
SRC_URI="http://www.manyfish.co.uk/pakchois/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="nls"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable nls)
}
