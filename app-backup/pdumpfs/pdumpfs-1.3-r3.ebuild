# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A daily backup system similar to Plan9's dumpfs"
HOMEPAGE="http://0xcc.net/pdumpfs/"
SRC_URI="http://0xcc.net/pdumpfs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="l10n_ja"

DEPEND=">=dev-lang/ruby-2.7.4"

PATCHES=(
	"${FILESDIR}/${PN}-in-r3.patch"
	"${FILESDIR}/${PN}-test-r3.patch"
)

src_compile() {
	emake pdumpfs
}

src_test() {
	# RUBYOPT=-rauto_gem without rubygems installed will cause ruby to fail, bug #158455 and #163473.
	export RUBYOPT="${GENTOO_RUBYOPT}"
	emake check
}

src_install() {
	dobin pdumpfs

	doman man/man8/pdumpfs.8
	dodoc -r doc/*

	if use l10n_ja; then
		insinto /usr/share/man/ja/man8
		doins man/ja/man8/pdumpfs.8
	fi

	dodoc ChangeLog README
}
