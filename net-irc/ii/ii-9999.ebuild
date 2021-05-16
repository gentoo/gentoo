# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 toolchain-funcs

DESCRIPTION="A minimalist FIFO and filesystem-based IRC client"
HOMEPAGE="https://tools.suckless.org/ii/"
EGIT_REPO_URI="https://git.suckless.org/ii"

LICENSE="MIT"
SLOT="0"

src_prepare() {
	default

	sed -i -e '/^LDFLAGS/{s:-s::g; s:= :+= :g}' \
		-e '/^CFLAGS/{s: -Os::g; s:= :+= :g}' config.mk || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}"/usr \
		DOCPREFIX="${EPREFIX}"/usr/share/doc/${PF} \
		install
}
