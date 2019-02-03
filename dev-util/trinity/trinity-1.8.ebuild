# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="A Linux system call fuzz tester"
HOMEPAGE="http://codemonkey.org.uk/projects/trinity/"
SRC_URI="http://codemonkey.org.uk/projects/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

# We need newer headers to avoid compilation failures in the BPF stuff.
DEPEND="
	>=sys-kernel/linux-headers-4.8
"
RDEPEND=""

PATCHES=(
	# Fixes from Fedora and Debian
	"${FILESDIR}"/${PN}-autofs.patch
	"${FILESDIR}"/${PN}-irda.patch
	"${FILESDIR}"/${PN}-memfd.patch
	"${FILESDIR}"/${PN}-net-protocols.patch
)

src_configure() {
	tc-export CC
	default
}

src_compile() {
	# Enable a verbose (i.e. not quiet) build.
	emake V=1
}

src_install() {
	dobin "${PN}"
	dodoc Documentation/*
	einstalldocs

	if use examples ; then
		exeinto "/usr/share/doc/${PF}/scripts"
		doexe scripts/*
		docompress -x "/usr/share/doc/${PF}/scripts"
	fi
}
