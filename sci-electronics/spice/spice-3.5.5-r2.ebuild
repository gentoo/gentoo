# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit eutils flag-o-matic multilib

IUSE=""

MY_P="spice3f5sfix"
DESCRIPTION="general-purpose circuit simulation program"
HOMEPAGE="http://bwrc.eecs.berkeley.edu/Classes/IcBook/SPICE/"
SRC_URI="http://www.ibiblio.org/pub/Linux/apps/circuits/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="sys-libs/ncurses:0
	x11-libs/libXaw
	>=app-misc/editor-wrapper-3"

DEPEND="${RDEPEND}
	x11-proto/xproto"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# spice accepts -O1 at most
	replace-flags -O* -O1

	# Avoid re-creating WORKDIR due to stupid mtime
	touch ..

	sed -i -e "s:termcap:ncurses:g" \
		-e "s:joe:/usr/libexec/editor:g" \
		-e "s:-O2 -s:${CFLAGS}:g" \
		-e "s:-lncurses -lm -s:-lncurses -lm ${LDFLAGS}:" \
		-e "s:SPICE_DIR)/lib:SPICE_DIR)/$(get_libdir)/spice:g" \
		-e "s:/usr/local/spice:/usr:g" \
		-e "s:/X11R6::" \
		conf/linux || die
	sed -i -e "s:head -1:head -n 1:" util/build || die
	epatch "${FILESDIR}"/${P}-gcc-4.1.patch

	# fix possible buffer overflow (bug #339539)
	sed -i -e "s:fgets(buf, BSIZE_SP:fgets(buf, sizeof(buf):g" \
		src/lib/fte/misccoms.c || die

	# fix missing libtinfo if ncurses compiled with USE=tinfo (bug #605718)
	if has_version 'sys-libs/ncurses:0[tinfo]' ;then
		sed -i -e "s:-lncurses:-lncurses -ltinfo:g" conf/linux || die
	fi

	eapply_user
}

src_compile() {
	./util/build linux || die "build failed"
	obj/bin/makeidx lib/helpdir/spice.txt || die "makeidx failed"
}

src_install() {
	# install binaries
	dobin obj/bin/{spice3,nutmeg,sconvert,multidec,proc2mod}
	newbin obj/bin/help spice.help
	dosym /usr/bin/spice3 /usr/bin/spice
	# install runtime stuff
	rm -f lib/make*
	dodir /usr/$(get_libdir)/spice
	cp -R lib/* "${D}"/usr/$(get_libdir)/spice/ || die "failed to copy libraries"
	# install docs
	doman man/man1/*.1
	dodoc readme readme.Linux notes/spice2
}
