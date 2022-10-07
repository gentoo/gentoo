# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

POPPLER_DATA_EXTRA_VERSION="0.4.11-2"
DESCRIPTION="Data files for poppler to support uncommon encodings without xpdfrc"
HOMEPAGE="https://poppler.freedesktop.org/"
SRC_URI="https://poppler.freedesktop.org/${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-${POPPLER_DATA_EXTRA_VERSION}-extra.tar.xz"

# AGPL-3+ for the extra files needed by ghostscript, bug #844115
LICENSE="AGPL-3+ BSD GPL-2 MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

src_install() {
	emake prefix="${EPREFIX}"/usr DESTDIR="${D}" install

	# We need to include extra cMaps for ghostscript, bug #844115
	cp "${WORKDIR}"/${PN}-${POPPLER_DATA_EXTRA_VERSION}-extra/Identity-* "${ED}"/usr/share/poppler/cMap || die

	# bug #409361
	dodir /usr/share/poppler/cMaps
	cd "${ED}"/usr/share/poppler/cMaps || die
	find ../cMap -type f -exec ln -s {} . \; || die
}
