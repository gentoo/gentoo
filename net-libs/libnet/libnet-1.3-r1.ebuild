# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool

# TODO: Fix upstream dist tarballs to include man pages!
# https://github.com/libnet/libnet/issues/169
#
# Generate using https://github.com/thesamesam/sam-gentoo-scripts/blob/main/niche/generate-libnet-docs
# Set to 1 if prebuilt, 0 if not
# (the construct below is to allow overriding from env for script)
: ${LIBNET_DOCS_PREBUILT:=1}

LIBNET_DOCS_PREBUILT_DEV=sam
LIBNET_DOCS_VERSION="${PV}"
# Default to generating docs (inc. man pages) if no prebuilt; overridden later
# bug #830088
LIBNET_DOCS_USEFLAG="+man"

DESCRIPTION="Library for commonly used low-level network functions"
HOMEPAGE="http://libnet-dev.sourceforge.net/ https://github.com/libnet/libnet"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"
if [[ ${LIBNET_DOCS_PREBUILT} == 1 ]] ; then
	SRC_URI+=" !man? ( https://dev.gentoo.org/~${LIBNET_DOCS_PREBUILT_DEV}/distfiles/${CATEGORY}/${PN}/${PN}-${LIBNET_DOCS_VERSION}-docs.tar.xz )"
	LIBNET_DOCS_USEFLAG="man"
fi

LICENSE="BSD BSD-2"
SLOT="1.1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="${LIBNET_DOCS_USEFLAG} static-libs test"
# Fails in sandbox, tries to access /proc/self/uid_map.
RESTRICT="!test? ( test ) test"

BDEPEND="
	man? ( app-text/doxygen )
	test? ( dev-util/cmocka )
"

DOCS=( ChangeLog.md README.md doc/MIGRATION.md )

src_prepare() {
	default
	elibtoolize
}

src_configure() {
	local myeconfargs=(
		$(use_enable man doxygen-doc)
		$(use_enable man doxygen-man)
		$(use_enable static-libs static)
		$(use_enable test tests)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if ! use man && [[ ${LIBNET_DOCS_PREBUILT} == 1 ]] ; then
		doman "${WORKDIR}"/${PN}-${LIBNET_DOCS_VERSION}-docs/man/*/*.[0-8]
	fi

	find "${D}" -name '*.la' -delete || die
}
