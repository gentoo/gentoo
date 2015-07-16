# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/dash/dash-0.5.8.2.ebuild,v 1.6 2015/07/16 15:49:40 klausman Exp $

EAPI="4"

inherit eutils flag-o-matic toolchain-funcs

DEB_PV=${PV%.*}
DEB_PATCH=${PV##*.}
DEB_PF="${PN}_${DEB_PV}-${DEB_PATCH}"
MY_P="${PN}-${DEB_PV}"

DESCRIPTION="DASH is a direct descendant of the NetBSD version of ash (the Almquist SHell) and is POSIX compliant"
HOMEPAGE="http://gondor.apana.org.au/~herbert/dash/"
SRC_URI="http://gondor.apana.org.au/~herbert/dash/files/${PN}-${DEB_PV}.tar.gz
	mirror://debian/pool/main/d/dash/${DEB_PF}.diff.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="libedit static"

RDEPEND="!static? ( libedit? ( dev-libs/libedit ) )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	libedit? ( static? ( dev-libs/libedit[static-libs] ) )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${WORKDIR}"/${DEB_PF}.diff
	epatch */debian/diff/*
	epatch "${FILESDIR}"/${PN}-0.5.8.1-dumb-echo.patch #337329 #527848
	epatch "${FILESDIR}"/${PN}-0.5.8.1-eval-warnx.patch

	# Fix the invalid sort
	sed -i -e 's/LC_COLLATE=C/LC_ALL=C/g' src/mkbuiltins

	# Use pkg-config for libedit linkage
	sed -i \
		-e "/LIBS/s:-ledit:\`$(tc-getPKG_CONFIG) --libs libedit $(usex static --static '')\`:" \
		configure || die
}

src_configure() {
	append-cppflags -DJOBS=$(usex libedit 1 0)
	use static && append-ldflags -static
	# Do not pass --enable-glob due to #443552.
	# Autotools use $LINENO as a proxy for extended debug support
	# (i.e. they're running bash), so disable that. #527644
	econf \
		--bindir="${EPREFIX}"/bin \
		--enable-fnmatch \
		--disable-lineno \
		$(use_with libedit)
}

src_install() {
	default
	dodoc */debian/changelog
}
