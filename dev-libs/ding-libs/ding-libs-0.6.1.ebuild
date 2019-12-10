# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit multilib-minimal

DESCRIPTION="set of utility libraries (mostly used by sssd)"
HOMEPAGE="https://pagure.io/SSSD/ding-libs"
SRC_URI="https://releases.pagure.org/SSSD/${PN}/${P}.tar.gz"

LICENSE="LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-linux"
IUSE="test static-libs"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-libs/check )"

PATCHES=(
	"${FILESDIR}"/0000-INI-Fix-detection-of-error-messages.patch
	"${FILESDIR}"/0001-path_utils_ut-allow-single-as-well.patch
	"${FILESDIR}"/0002-validators_ut_check-Fix-fail-with-new-glibc.patch
)

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}
