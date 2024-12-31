# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV_TSR="20240920"

inherit systemd toolchain-funcs

DESCRIPTION="A network-backed floppy emulator for DOS"
HOMEPAGE="https://ethflop.sourceforge.net/"
SRC_URI="
	https://ethflop.sourceforge.net/${PN}d-${PV}-src.tar.gz
	tsr? ( https://ethflop.sourceforge.net/${PN}-${MY_PV_TSR}-src.zip )
"
S="${WORKDIR}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tsr"
RESTRICT="test"

BDEPEND="
	app-arch/unzip
	tsr? ( dev-lang/nasm )
"

PATCHES="${FILESDIR}/${PN}-20240916-makefile.patch"

src_prepare() {
	default
	mv Makefile.linux Makefile || die
	# Files are shipped uppercase, but need to be lowercase
	if use tsr; then
		for file in *.ASM *.SH; do
			mv ${file} ${file,,} || die
		done
		chmod +x build.sh || die
	fi
}

src_compile() {
	tc-export CC
	default

	if use tsr; then
		./build.sh || die
	fi
}

src_install() {
	dobin ethflopd

	if use tsr; then
		insinto /usr/share/ethflop
		doins ethflop.com
	fi

	newinitd "${FILESDIR}"/ethflopd.initd ethflopd
	newconfd "${FILESDIR}"/ethflopd.confd ethflopd
	systemd_newunit "${FILESDIR}"/ethflopd.service-r1 ethflopd.service
}
