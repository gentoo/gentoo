# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI=( {https,git}://github.com/pkgconf/${PN}.git )
	inherit autotools git-r3
else
	SRC_URI="https://distfiles.dereferenced.org/pkgconf/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh
		~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux
		~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc64-solaris ~x64-solaris"
fi

inherit multilib-minimal

DESCRIPTION="pkg-config compatible replacement with no dependencies other than ANSI C89"
HOMEPAGE="https://github.com/pkgconf/pkgconf"

LICENSE="BSD-1"
SLOT="0"
IUSE="+pkg-config strict"

DEPEND=""
RDEPEND="${DEPEND}
	pkg-config? (
		!dev-util/pkgconfig
		!dev-util/pkg-config-lite
		!dev-util/pkgconfig-openbsd[pkg-config]
	)"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/pkgconf
)

src_prepare() {
	default

	[[ ${PV} == "9999" ]] && eautoreconf
	if use pkg-config; then
		MULTILIB_CHOST_TOOLS+=(
			/usr/bin/pkg-config
		)
	fi
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf $(use_enable strict)
}

multilib_src_install() {
	default

	if use pkg-config; then
		dosym pkgconf /usr/bin/pkg-config
	else
		rm "${ED%/}"/usr/share/aclocal/pkg.m4 || die
	fi
}
