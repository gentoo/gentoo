# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KJOHNSON
DIST_VERSION=0.02
DIST_EXAMPLES=("examples/*")

inherit perl-module

PATCH_BASE="${PN}-0.02-patches-1"

DESCRIPTION="A base class for protocols such as IMAP, ACAP, IMSP, and ICAP"
SRC_URI+=" 	mirror://gentoo/${PATCH_BASE}.tar.xz  https://dev.gentoo.org/~kentnl/distfiles/${PATCH_BASE}.tar.xz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="virtual/perl-MIME-Base64
	dev-perl/MD5
	dev-perl/Digest-HMAC
	virtual/perl-Digest-MD5
"
DEPEND="${RDEPEND}
	test? (
		net-mail/uw-imap
	)
"
src_prepare() {
	eapply "${WORKDIR}/patches"
	perl-module_src_prepare
}
