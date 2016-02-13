# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/pkgconf/pkgconf.git"
	inherit autotools git-2 multilib-minimal
else
	inherit eutils multilib-minimal
	SRC_URI="http://rabbit.dereferenced.org/~nenolod/distfiles/${P}.tar.bz2"
	KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc64-solaris ~x64-solaris"
fi

DESCRIPTION="pkg-config compatible replacement with no dependencies other than ANSI C89"
HOMEPAGE="https://github.com/pkgconf/pkgconf"

LICENSE="BSD-1"
SLOT="0"
IUSE="+pkg-config strict"

RESTRICT="test" # at least until 0.9.13

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
	[[ -e configure ]] || eautoreconf

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
	use pkg-config \
		&& dosym pkgconf /usr/bin/pkg-config \
		|| rm "${ED}"/usr/share/aclocal/pkg.m4 \
		|| die
}
