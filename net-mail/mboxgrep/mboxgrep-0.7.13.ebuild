# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools edo

DESCRIPTION="Grep for mbox files"
HOMEPAGE="https://mboxgrep.org/"
SRC_URI="https://github.com/dspiljar/mboxgrep/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+pcre"

RDEPEND="
	app-arch/bzip2
	sys-libs/zlib
	pcre? ( dev-libs/libpcre2:=[pcre32] )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.13-rm_getopt.patch
	# PR merged https://github.com/dspiljar/mboxgrep/pull/6.patch
	# (except commit for getopt)
	"${FILESDIR}"/${P}-fix_c23.patch
)

DOCS=( AUTHORS.md NEWS.md README.md TODO.md )

src_prepare() {
	default

	# Remove old getopt part. It just works with getopt.h from glibc or musl.
	rm src/getopt.h || die

	eautoreconf
}

src_configure() {
	econf $(usev !pcre --without-pcre2)
}

src_test() {
	# create a mail
	cat > "${T}"/mailtest <<-_EOF_ || die
	From fake@example.com Mon Sep 17 00:00:00 2001
	From: FAKE USER <fake@example.com>
	Date: Mon, 28 Jul 2025 00:00:00 +0200
	Subject: [TEST] Basic
	To: test@example.com

	Bla
	_EOF_
	# delete the content if it matches
	edo ./src/mboxgrep --debug --mailbox-format=mbox --delete \
		'^To:\s([a-z]{4})\@\w+\.([a-z]{3})$' "${T}"/mailtest
	[[ -s "${T}"/mailtest ]] && die "Test failed. ${T}/mailtest should be empty."
}
