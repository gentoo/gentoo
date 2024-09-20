# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/ColinIanKing/${PN}.git"

inherit bash-completion-r1 git-r3 toolchain-funcs

DESCRIPTION="Laptop power measuring tool"
HOMEPAGE="https://launchpad.net/ubuntu/+source/powerstat https://github.com/ColinIanKing/powerstat"

LICENSE="GPL-2+"
SLOT="0"

src_prepare() {
	default

	# Don't compress manpages, respect CFLAGS
	sed -i  -e '/install:/s/ powerstat.8.gz//' \
		-e '/cp powerstat.8/s/.gz//' \
		-e '/CFLAGS += -Wall/s| -O2||' \
		Makefile || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default
	dobashcomp bash-completion/powerstat
}
