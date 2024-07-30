# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 toolchain-funcs

DESCRIPTION="Laptop power measuring tool"
HOMEPAGE="https://launchpad.net/ubuntu/+source/powerstat https://github.com/ColinIanKing/powerstat"
EGIT_REPO_URI="https://github.com/ColinIanKing/${PN}.git"

LICENSE="GPL-2+"
SLOT="0"

src_prepare() {
	default

	# Don't compress manpages
	sed -i  -e '/install:/s/ powerstat.8.gz//' \
		-e '/cp powerstat.8/s/.gz//' \
		Makefile || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)"
}
