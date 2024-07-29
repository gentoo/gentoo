# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Purely functional dialect of Scheme"
HOMEPAGE="https://haltp.org/posts/owl.html
	https://gitlab.com/owl-lisp/owl/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/owl-lisp/owl.git"
else
	SRC_URI="https://gitlab.com/owl-lisp/owl/-/archive/v${PV}/owl-v${PV}.tar.bz2"
	KEYWORDS="~amd64"
	S="${WORKDIR}/owl-v${PV}"
fi

LICENSE="MIT"
SLOT="0"

PATCHES=( "${FILESDIR}"/${PN}-0.2.1-make-no-test.patch )

src_prepare() {
	default

	# Skip "tests/char-ready.sh", "does not work in background subshell".
	rm tests/char-ready.sh || die
}

src_compile(){
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" owl
}

src_install() {
	exeinto /usr/bin
	doexe "${S}"/bin/ol
	newexe "${S}"/bin/vm ovm

	doman "${S}"/doc/*.1

	einstalldocs
}
