# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils libtool

DESCRIPTION="A documentation metadata library"
HOMEPAGE="https://rarian.freedesktop.org/"
SRC_URI="https://${PN}.freedesktop.org/Releases/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND="dev-libs/libxslt
	|| ( sys-apps/util-linux app-misc/getopt )"
DEPEND="${RDEPEND}
	!<app-text/scrollkeeper-9999"

DOCS=( ChangeLog NEWS README )

src_prepare() {
	# Fix uri of omf files produced by rarian-sk-preinstall, see bug #302900
	epatch "${FILESDIR}/${P}-fix-old-doc.patch"

	# remove unneeded line, bug #240564
	sed "s/ (foreign dist-bzip2 dist-gzip)//" -i configure || die "sed failed"

	# bug #409811, https://bugs.freedesktop.org/show_bug.cgi?id=53264
	# sed to avoid autoreconf
	if ! has_version sys-apps/util-linux; then
		sed -e 's/getopt -/getopt-long -/' \
			-i util/rarian-sk-update.in || die "sed 2 failed"
	fi

	elibtoolize ${ELTCONF}
}

src_configure() {
	econf \
		--localstatedir="${EPREFIX}"/var \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
