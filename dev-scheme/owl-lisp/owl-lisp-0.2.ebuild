# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTICE: Because it is "purely functional" it is not scheme-compatible ootb

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Purely functional dialect of Scheme"
HOMEPAGE="https://haltp.org/posts/owl.html"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/owl-lisp/owl.git"
else
	SRC_URI="https://gitlab.com/owl-lisp/owl/-/archive/v${PV}/owl-v${PV}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/owl-v${PV}"
fi

LICENSE="MIT"
SLOT="0"

src_prepare() {
	default

	sed -i 's|make bin/vm|$(MAKE) bin/vm|g' ./Makefile || die
}

src_compile(){
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" owl
}

src_install() {
	einstalldocs

	dobin ./bin/ol
	newbin ./bin/vm ovm

	doman ./doc/*.1
}
