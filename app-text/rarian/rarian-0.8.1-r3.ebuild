# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils

DESCRIPTION="A documentation metadata library"
HOMEPAGE="https://rarian.freedesktop.org/"
SRC_URI="https://${PN}.freedesktop.org/Releases/${P}.tar.gz
	https://dev.gentoo.org/~eva/distfiles/${PN}/${P}-r3-patches.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND="
	dev-libs/libxslt
	dev-libs/tinyxml
	|| (
		sys-apps/util-linux
		app-misc/getopt )
"
DEPEND="${RDEPEND}
	!<app-text/scrollkeeper-9999
"

DOCS=( ChangeLog NEWS README )

PATCHES=(
	"${WORKDIR}"/0001-Fix-uri-of-omf-files-produced-by-rarian-sk-preinstal.patch
	"${WORKDIR}"/0002-Allow-building-against-system-copy-of-tinyxml.patch
	"${WORKDIR}"/0003-Allow-to-specify-only-the-prefix-of-an-info-page-e.g.patch
	"${WORKDIR}"/0004-Fix-a-crash-when-opening-files-without-dots-in-their.patch
	"${WORKDIR}"/0005-Make-librarian-obey-to-LC_MESSAGES.patch
	"${WORKDIR}"/0006-Fix-m4-syntax-so-that-autoreconf-doesn-t-break.patch
	"${WORKDIR}"/0007-Remove-the-nonexistent-dist-gzip-Automake-option.patch
	"${WORKDIR}"/0008-Fix-OMF-category-parsing.patch
	"${WORKDIR}"/0009-Allow-the-getopt-command-to-be-customized-at-configu.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=()
	# https://bugs.gentoo.org/show_bug.cgi?id=409811
	# https://bugs.freedesktop.org/show_bug.cgi?id=53264
	if ! has_version sys-apps/util-linux; then
		myconf=( --with-getopt=getopt-long )
	fi

	econf \
		--localstatedir="${EPREFIX}"/var \
		$(use_enable static-libs static) \
		${myconf[@]}
}

src_install() {
	default
	prune_libtool_files --all
}
