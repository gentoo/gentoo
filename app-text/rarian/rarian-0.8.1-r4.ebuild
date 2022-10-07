# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A documentation metadata library"
HOMEPAGE="https://rarian.freedesktop.org/"
SRC_URI="
	https://${PN}.freedesktop.org/Releases/${P}.tar.gz
	https://dev.gentoo.org/~soap/distfiles/${P}-r4-patches.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris ~x86-solaris"

RDEPEND="
	dev-libs/libxslt
	dev-libs/tinyxml
	|| (
		sys-apps/util-linux
		app-misc/getopt
	)"
DEPEND="${RDEPEND}"

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
	"${WORKDIR}"/0010-Wimplicit-int.patch
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
		"${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
