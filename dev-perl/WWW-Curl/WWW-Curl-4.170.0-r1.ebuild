# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SZBALINT
DIST_VERSION=4.17
inherit perl-module

DESCRIPTION="Perl extension interface for libcurl"

LICENSE="|| ( MPL-1.0 MPL-1.1 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="net-misc/curl"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.150.0-curl-7.50.2.patch
	"${FILESDIR}"/${PN}-4.17-dotinc.patch
	"${FILESDIR}"/${PN}-4.17-networktests.patch
)
PERL_RM_FILES=("t/meta.t" "t/pod-coverage.t" "t/pod.t")
