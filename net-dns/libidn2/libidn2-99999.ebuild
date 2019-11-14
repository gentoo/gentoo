# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3 multilib-minimal

DESCRIPTION="An implementation of the IDNA2008 specifications (RFCs 5890, 5891, 5892, 5893)"
HOMEPAGE="https://www.gnu.org/software/libidn/#libidn2 https://gitlab.com/libidn/libidn2"
EGIT_REPO_URI="https://gitlab.com/libidn/libidn2.git/"
SRC_URI="mirror://gnu/libunistring/libunistring-0.9.10.tar.gz"

LICENSE="GPL-2+ LGPL-3+"
SLOT="0/2"
KEYWORDS=""
IUSE="static-libs"

RDEPEND="
	dev-libs/libunistring[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	dev-util/gengetopt
	sys-apps/help2man
"
S=${WORKDIR}/${P/a/}

src_unpack() {
	git-r3_src_unpack
	unpack ${A}
}

src_prepare() {
	mv "${WORKDIR}"/libunistring-0.9.10 unistring || die

	AUTORECONF=: sh bootstrap \
		--gnulib-srcdir=gnulib --no-bootstrap-sync --no-git --skip-po \
	|| die

	default

	eautoreconf

	if [[ ${CHOST} == *-darwin* ]] ; then
		# Darwin ar chokes when TMPDIR doesn't exist (as done for some
		# reason in the Makefile)
		sed -i -e '/^TMPDIR = /d' Makefile.in || die
		export TMPDIR="${T}"
	fi

	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		$(use_enable static-libs static) \
		--disable-doc \
		--disable-gcc-warnings \
		--disable-gtk-doc \
		--disable-silent-rules
}

multilib_src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
