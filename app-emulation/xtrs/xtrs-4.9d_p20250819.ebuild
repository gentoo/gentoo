# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit eapi9-ver toolchain-funcs readme.gentoo-r1

COMMIT="3a2180c063811a715faa28d39a94739c33e0abd0"
DESCRIPTION="Radio Shack TRS-80 emulator"
HOMEPAGE="https://www.tim-mann.org/xtrs.html"
SRC_URI="https://github.com/TimothyPMann/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	ls-dos? (
		https://www.tim-mann.org/trs80/ld4-631.zip
		https://dev.gentoo.org/~ulm/distfiles/ld4-631l.xd3
	)"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="xtrs MIT ls-dos? ( freedist )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="ls-dos"
RESTRICT="ls-dos? ( bindist )"

RDEPEND="sys-libs/ncurses:0=
	sys-libs/readline:0=
	x11-libs/libX11"
DEPEND="${RDEPEND}"
BDEPEND="dev-embedded/zmac
	ls-dos? ( app-arch/unzip dev-util/xdelta:3 )"

src_prepare() {
	default

	if use ls-dos; then
		cd "${WORKDIR}" || die
		xdelta3 -d -s ld4-631.dsk "${DISTDIR}"/ld4-631l.xd3 out.dsk || die
		mv out.dsk ld4-631.dsk || die
	fi
}

src_compile() {
	local endian=""
	case $(tc-endian) in
		little) ;;
		big) endian="-Dbig_endian" ;;
		*) die ;;
	esac

	emake \
		CC="$(tc-getCC)" \
		DEBUG="${CFLAGS} -std=gnu17" \
		LDFLAGS="${LDFLAGS}" \
		ENDIAN="${endian}" \
		ZMACFLAGS="-h -l" \
		HTMLDOCS=
}

src_install() {
	emake DESTDIR="${ED}" install-progs

	insinto /usr/share/xtrs/disks
	insopts -m0444
	doins cpmutil.dsk utility.dsk

	if use ls-dos; then
		doins "${WORKDIR}"/ld4-631.dsk
		dosym disks/ld4-631.dsk /usr/share/xtrs/disk4p-0
		dosym disks/utility.dsk /usr/share/xtrs/disk4p-1
	fi

	local f
	for f in xtrs cassette mkdisk cmddump hex2cmd; do
		newman ${f}.man ${f}.1
	done

	dodoc AUTHORS ChangeLog README xtrsrom4p.README cpmutil.html dskspec.html

	local DOC_CONTENTS="For copyright reasons, xtrs does not include actual
		ROM images. Because of this, unless you supply your own ROM, xtrs
		will not function in any mode except 'Model 4p' mode (a minimal
		free ROM is included for this), which can be run like this:
		\n\nxtrs -model 4p -diskdir /usr/share/xtrs
		\n\nIf you already own a copy of the ROM software (e.g., if you have
		a TRS-80 with this ROM), then you can make yourself a copy of this
		for use with xtrs, using utilities available on the web. To load
		your own ROM, specify the '-romfile1' option, or the 'Xtrs.romfile1'
		X resource. ROM files can be in Intel hex or binary format."
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	if ver_replacing -lt 4.9d_p; then
		elog "The option and X resource to load a ROM file for the Model I"
		elog "have been renamed:"
		elog "'-romfile1' (instead of '-romfile') for the option,"
		elog "'Xtrs.romfile1' (instead of 'Xtrs.romfile') for the X resource"
	fi
}
