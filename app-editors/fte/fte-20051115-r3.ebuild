# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Lightweight text-mode editor"
HOMEPAGE="http://fte.sourceforge.net"
SRC_URI="
	mirror://sourceforge/fte/${P}-src.zip
	mirror://sourceforge/fte/${P}-common.zip"

LICENSE="|| ( GPL-2 Artistic )"
SLOT="0"
KEYWORDS="~alpha amd64 ppc -sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="gpm slang X"

S="${WORKDIR}/${PN}"

RDEPEND="
	>=sys-libs/ncurses-5.2
	X? (
		x11-libs/libXdmcp
		x11-libs/libXau
		x11-libs/libX11
		x11-libs/libXpm
	)
	gpm? ( >=sys-libs/gpm-1.20 )"
DEPEND="${RDEPEND}
	slang? ( >=sys-libs/slang-2.1.3 )
	app-arch/unzip"

set_targets() {
	export TARGETS=""
	use slang && TARGETS="${TARGETS} sfte"
	use X && TARGETS="${TARGETS} xfte"

	[[ ${CHOST} == *-linux-gnu* ]] \
		&& TARGETS="${TARGETS} vfte" \
		|| TARGETS="${TARGETS} nfte"
}

src_prepare() {
	epatch \
		"${FILESDIR}"/fte-gcc34 \
		"${FILESDIR}"/${PN}-new_keyword.patch \
		"${FILESDIR}"/${PN}-slang.patch \
		"${FILESDIR}"/${PN}-interix.patch

	[[ -e /usr/include/linux/keyboard.h ]] && \
		sed /usr/include/linux/keyboard.h -e '/wait.h/d' > src/hacked_keyboard.h

	sed \
		-e "s:<linux/keyboard.h>:\"hacked_keyboard.h\":" \
		-i src/con_linux.cpp || die "sed keyboard"
	sed \
		-e 's:^OPTIMIZE:#&:g' \
		-e '/^LDFLAGS/s:=:+=:g' \
		-e 's:= g++:= $(CXX):g' \
		-i src/fte-unix.mak || die "sed CFLAGS, LDFLAGS, CC"
	ecvs_clean
}

src_configure() {
	set_targets
	sed \
		-e "s:@targets@:${TARGETS}:" \
		-e '/^XINCDIR  =/c\XINCDIR  =' \
		-e '/^XLIBDIR  =/c\XLIBDIR  = -lstdc++' \
		-e '/^SINCDIR   =/c\SINCDIR = -I'"${EPREFIX}"'/usr/include/slang' \
		-i src/fte-unix.mak || die "sed targets"

	if ! use gpm; then
		sed \
			-e "s:#define USE_GPM://#define USE_GPM:" \
			-i src/con_linux.cpp || die "sed USE_GPM"
		sed \
			-e "s:-lgpm::" \
			-i src/fte-unix.mak || die "sed -lgpm"
	fi
}

src_compile() {
	local os="-DLINUX" # by now the default in makefile
	[[ ${CHOST} == *-interix* ]] && os=

	DEFFLAGS="PREFIX='${EPREFIX}'/usr CONFIGDIR='${EPREFIX}'/usr/share/fte \
		DEFAULT_FTE_CONFIG=../config/main.fte UOS=${os}"

	set_targets
	emake CXX=$(tc-getCXX) OPTIMIZE="${CXXFLAGS}" ${DEFFLAGS} TARGETS="${TARGETS}" all
}

src_install() {
	local files

	keepdir /etc/fte

	into /usr

	set_targets
	files="${TARGETS} cfte"

	for i in ${files}; do
		dobin src/$i
	done

	dobin "${FILESDIR}"/fte

	dodoc CHANGES BUGS HISTORY README TODO
	dohtml doc/*

	insinto /usr/share/fte
	doins -r config/*
}

pkg_postinst() {
	ebegin "Compiling configuration"
	cd "${EPREFIX}"/usr/share/fte || die "missing configuration dir"
	"${EPREFIX}"/usr/bin/cfte main.fte "${EPREFIX}"/etc/fte/system.fterc
	eend $?
}
