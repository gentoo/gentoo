# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools eutils

# agedu-20151213.59b0ed3.ebuild is not a legitimate name
# so we'll drop versionator and just set MY_P manually.
MY_P="${PN}"-20180302.9421c00

DESCRIPTION="A utility for tracking down wasted disk space"
HOMEPAGE="https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
SRC_URI="https://www.chiark.greenend.org.uk/~sgtatham/agedu/${MY_P}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc ipv6"

DEPEND="doc? ( app-doc/halibut )"

src_prepare() {
	epatch "${FILESDIR}/${PN}-r9671-fix-automagic.patch"
	eapply_user
	eautoreconf
}

src_configure() {
	econf --enable-ipv4 \
		$(use_enable doc halibut) \
		$(use_enable ipv6)
}
