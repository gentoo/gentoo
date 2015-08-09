# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs versionator linux-info

MY_P="${PN}-$(get_version_component_range 1-2)"
DEBIAN_SOURCE="${PN}_$(get_version_component_range 1-2).orig.tar.gz"
DEBIAN_PATCH="${PN}_$(replace_version_separator 2 '-').debian.tar.gz"

DESCRIPTION="BSD build tool to create programs in parallel. Debian's version of NetBSD's make"
HOMEPAGE="http://www.netbsd.org/"
SRC_URI="mirror://debian/pool/main/p/pmake/${DEBIAN_SOURCE}
	mirror://debian/pool/main/p/pmake/${DEBIAN_PATCH}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}/${PN}"

src_prepare() {
	EPATCH_FORCE="yes" \
		EPATCH_OPTS="-g0 -E --no-backup-if-mismatch -p1" \
		EPATCH_SUFFIX="diff" \
		epatch "${WORKDIR}/debian/patches"

	# pmake makes the assumption that . and .. are the first two
	# entries in a directory, which doesn't always appear to be the
	# case on ext3...  (05 Apr 2004 agriffis)
	epatch "${FILESDIR}/${PN}-1.98-skipdots.patch"

	# Don't ignore ldflags
	epatch "${FILESDIR}/${PN}-1.111.1-ldflags.patch"
}

src_compile() {
	# The following CFLAGS are almost directly from Red Hat 8.0 and
	# debian/rules, so assume it's okay to void out the __COPYRIGHT
	# and __RCSID.  I've checked the source and don't see the point,
	# but whatever...  (07 Feb 2004 agriffis)
	CFLAGS="${CFLAGS} -Wall -Wno-unused -D_GNU_SOURCE \
		-DHAVE_STRERROR -DHAVE_STRDUP -DHAVE_SETENV \
		-D__COPYRIGHT\(x\)= -D__RCSID\(x\)= -I. \
		-DMACHINE=\\\"gentoo\\\" -DMACHINE_ARCH=\\\"$(tc-arch-kernel)\\\" \
		-D_PATH_DEFSHELLDIR=\\\"${EPREFIX}/bin\\\" \
		-D_PATH_DEFSYSPATH=\\\"${EPREFIX}/usr/share/mk\\\" \
		-DHAVE_VSNPRINTF"
	if [[ "${USERLAND}" == "GNU" ]]; then
		CFLAGS="${CFLAGS} -D_PATH_DEFSYSPATH=\\\"${EPREFIX}/usr/share/mk/${PN}\\\""
	fi

	emake -f Makefile.boot \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}"
}

src_install() {
	# Don't install these on BSD, else they conflict
	if [[ "${USERLAND}" == "GNU" ]]; then
		insinto /usr/share/mk/${PN}
		doins mk/*
	fi

	newbin bmake pmake
	dobin mkdep
	mv make.1 pmake.1
	doman mkdep.1 pmake.1
	dodoc PSD.doc/tutorial.ms

	if [[ "${USERLAND}" == "BSD" ]]; then
		dosym pmake /usr/bin/make
		dosym pmake.1.gz /usr/share/man/man1/make.1.gz
	fi
}
