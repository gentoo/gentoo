# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic toolchain-funcs readme.gentoo

DESCRIPTION="Radio Shack TRS-80 emulator"
HOMEPAGE="http://www.tim-mann.org/xtrs.html"
SRC_URI="http://www.tim-mann.org/trs80/${P}.tar.gz
	ls-dos? (
		http://www.tim-mann.org/trs80/ld4-631.zip
		https://dev.gentoo.org/~ulm/distfiles/ld4-631l.xd3
	)"

LICENSE="xtrs ls-dos? ( freedist )"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE="ls-dos"
RESTRICT="ls-dos? ( bindist )"

RDEPEND="sys-libs/ncurses:0
	sys-libs/readline:0
	>=x11-libs/libX11-1.0.0"
DEPEND="${RDEPEND}
	ls-dos? ( app-arch/unzip dev-util/xdelta:3 )"

src_prepare() {
	sed -i -e 's/$(CC) -o/$(CC) $(LDFLAGS) -o/' Makefile || die
	if use ls-dos; then
		cd "${WORKDIR}" || die
		xdelta3 -d -s ld4-631.dsk "${DISTDIR}"/ld4-631l.xd3 out.dsk || die
		mv out.dsk ld4-631.dsk || die
	fi
}

src_compile() {
	use ppc && append-flags -Dbig_endian
	emake CC="$(tc-getCC)" DEBUG="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dodir /usr/bin /usr/share/xtrs/disks /usr/share/man/man1
	emake PREFIX="${D}"/usr install

	insopts -m0444
	insinto /usr/share/xtrs/disks
	doins cpmutil.dsk utility.dsk

	if use ls-dos; then
		doins "${WORKDIR}"/ld4-631.dsk
		dosym disks/ld4-631.dsk /usr/share/xtrs/disk4p-0
		dosym disks/utility.dsk /usr/share/xtrs/disk4p-1
	fi

	dodoc ChangeLog README xtrsrom4p.README cpmutil.html dskspec.html

	DOC_CONTENTS="For copyright reasons, xtrs does not include actual ROM
		images. Because of this, unless you supply your own ROM, xtrs will
		not function in any mode except 'Model 4p' mode (a minimal free ROM
		is included for this), which can be run like this:
		\n\nxtrs -model 4p -diskdir /usr/share/xtrs
		\n\nIf you already own a copy of the ROM software (e.g., if you have
		a TRS-80 with this ROM), then you can make yourself a copy of this
		for use with xtrs, using utilities available on the web. To load
		your own ROM, specify the '-romfile' option, or the 'Xtrs.romfile'
		X resource. ROM files can be in Intel hex or binary format."
	readme.gentoo_create_doc
}
