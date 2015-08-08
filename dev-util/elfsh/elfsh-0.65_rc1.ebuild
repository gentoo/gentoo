# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="scripting language to modify ELF binaries"
HOMEPAGE="http://www.eresi-project.org/"
SRC_URI="mirror://gentoo/${P}.zip"
#http://www.eresi-project.org/browser/tags/elfsh_0_65rc1

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="readline"

DEPEND=">=dev-libs/expat-1.95
	readline? ( sys-libs/readline )
	app-arch/unzip
	dev-libs/libhash"
RDEPEND=""

S="${WORKDIR}/tags/elfsh_0_65rc1"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e 's: -O2 : :g' \
		-e "s: -g3 : ${CFLAGS} :" \
		-e "/^LDFLAGS/s:=:=${LDFLAGS} :" \
		$(find -name Makefile) \
		|| die
	chmod +x configure
}

src_compile() {
	local bits
	touch foo.c && $(tc-getCC) -c foo.c -o foo.o || die
	case $(file foo.o) in
		*64-bit*)  bits=64;;
		*32-bit*)  bits=32;;
		*)         die "unknown bits: $(file foo.o)";;
	esac
	# not an autoconf script
	./configure \
		$([[ ${bits} == "64" ]] && echo "--enable-m64") \
		--enable-${bits} \
		$(use_enable readline) \
		|| die
	# emacs does not have to be a requirement.
	emake ETAGS=echo || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die "install failed"
	dodoc README.FIRST doc/AUTHOR doc/CREDITS doc/Changelog doc/*.txt
	doman doc/*.1
}
