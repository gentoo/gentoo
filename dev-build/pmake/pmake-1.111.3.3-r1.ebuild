# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs linux-info

MY_P="${PN}-$(ver_cut 1-2)"
DEBIAN_SOURCE="${PN}_$(ver_cut 1-2).orig.tar.gz"
DEBIAN_PATCH="${PN}_$(ver_rs 2 '-').debian.tar.gz"

DESCRIPTION="BSD build tool to create programs in parallel. Debian's version of NetBSD's make"
HOMEPAGE="http://www.netbsd.org/"
SRC_URI="
	mirror://debian/pool/main/p/pmake/${DEBIAN_SOURCE}
	mirror://debian/pool/main/p/pmake/${DEBIAN_PATCH}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${WORKDIR}"/debian/patches

	# pmake makes the assumption that . and .. are the first two
	# entries in a directory, which doesn't always appear to be the
	# case on ext3...  (05 Apr 2004 agriffis)
	"${FILESDIR}"/${PN}-1.98-skipdots.patch

	# Don't ignore ldflags
	"${FILESDIR}"/${PN}-1.111.1-ldflags.patch
)

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
		-DHAVE_VSNPRINTF -D_PATH_DEFSYSPATH=\\\"${EPREFIX}/usr/share/mk/${PN}\\\""

	emake -f Makefile.boot \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}"
}

src_install() {
	insinto /usr/share/mk/${PN}
	doins -r mk/.

	newbin bmake pmake
	dobin mkdep

	doman mkdep.1
	newman make.1 pmake.1

	dodoc PSD.doc/tutorial.ms
}
