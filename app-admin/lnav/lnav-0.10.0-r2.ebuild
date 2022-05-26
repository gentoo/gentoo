# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A curses-based tool for viewing and analyzing log files"
HOMEPAGE="https://lnav.org"
SRC_URI="https://github.com/tstack/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="unicode test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/bzip2:0=
	app-arch/libarchive:=
	test? ( dev-cpp/doctest )
	>=dev-db/sqlite-3.9.0
	dev-libs/libpcre[cxx]
	>=net-misc/curl-7.23.0
	sys-libs/ncurses:=[unicode(+)?]
	sys-libs/readline:0=
	sys-libs/zlib:0="
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README )
PATCHES=(
	"${FILESDIR}"/${PN}-0.10.0-disable-tests.patch
	"${FILESDIR}"/${PN}-0.10.0-disable-remote-tests.patch
	# This allows us to use the --with-system-doctest configure flag, and should not be needed in
	# the next release of lnav. See https://github.com/tstack/lnav/pull/915
	# This patch isn't completely identical to the one in PR #915 because that patch was too large
	# for repoman's tastes. See the comment in src_prepare() for how I applied the rest of this
	# patch with rm and a heredoc.
	# https://bugs.gentoo.org/812353
	"${FILESDIR}"/${PN}-0.10.0-use-system-doctest.patch
)

src_prepare() {
	# repoman didn't like having a ~500 kiB patch file, so I'm just manually removing the doctest we
	# don't want (the bundled one) and putting the one we do want here.
	# We won't need this once we get rid of lnav-0.10.0-use-system-doctest.patch
	cat <<EOF > src/doctest.hh
#include "config.h"
#include DOCTEST_HEADER
EOF
	# We won't need this once we get rid of lnav-0.10.0-use-system-doctest.patch
	touch src/doctest_vendored.hh
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_with test system-doctest) \
		$(use_with unicode ncursesw)
}
