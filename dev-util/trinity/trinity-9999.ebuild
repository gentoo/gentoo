# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs git-r3

EGIT_REPO_URI="https://github.com/kernelslacker/trinity.git"

DESCRIPTION="A Linux system call fuzz tester"
HOMEPAGE="http://codemonkey.org.uk/projects/trinity/ https://github.com/kernelslacker/trinity/"

LICENSE="GPL-2"
SLOT="0"
IUSE="examples"

# We need newer headers to avoid compilation failures in the BPF stuff.
DEPEND="
	>=sys-kernel/linux-headers-4.8
"

src_prepare() {
	sed -e 's/-g -O2//' \
		-e 's/-D_FORTIFY_SOURCE=2//' \
		-e 's/-Werror//' \
		-e '/-o $@/s/$(LDFLAGS) //' \
		-i Makefile || die

	tc-export CC
	default
}

src_compile() {
	emake V=1
}

src_install() {
	dobin ${PN}
	dodoc Documentation/* README
	doman trinity.1

	if use examples ; then
		exeinto /usr/share/doc/${PF}/scripts
		doexe scripts/*
		docompress -x /usr/share/doc/${PF}/scripts
	fi
}
