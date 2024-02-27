# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="A set of CUPS printer drivers for SPL (Samsung Printer Language) printers"
HOMEPAGE="https://splix.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.bz2
	https://dev.gentoo.org/~voyageur/distfiles/samsung-cms-20120312.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="+jbig"

DEPEND=">=app-text/ghostscript-gpl-9.02
	>=net-print/cups-1.4.0
	jbig? ( media-libs/jbigkit )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-algo0x11_le.patch )

src_prepare() {
	default

	# Move to correct place
	mv *.ppd ppd/
	# Honor LDFLAGS
	sed -e "/[a-z]_LDFLAGS/s/:=.*/:= $\{LDFLAGS\}/" -i module.mk \
		|| die
	# Correct link comand
	sed -e "s/g++/$\{LINKER\}/" -i rules.mk \
		|| die
}

src_compile() {
	local options="MODE=optimized"
	use jbig || options="${options} DISABLE_JBIG=1"
	emake ${options} PSTORASTER=gstoraster CXX="$(tc-getCXX)" \
		OPTIM_CFLAGS="${CFLAGS}" OPTIM_CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install
	gzip "${ED}"/$(cups-config --datadir)/model/*/*.ppd || die

	emake DESTDIR="${D}" CMSDIR="${WORKDIR}"/cms MANUFACTURER=samsung installcms
	# Add symlinks for xerox and dell models (installed in samsung)
	dosym $(cups-config --datadir)/profiles/samsung $(cups-config --datadir)/profiles/xerox
	dosym $(cups-config --datadir)/profiles/samsung $(cups-config --datadir)/profiles/dell
}

pkg_postinst() {
	ewarn "You *MUST* make sure that the PPD files that CUPS is using"
	ewarn "for actually installed printers are updated if you upgraded"
	ewarn "from a previous version of splix!"
	ewarn "Otherwise you will be unable to print (your printer might"
	ewarn "spit out blank pages etc.)."
	ewarn "To do that, simply delete the corresponding PPD file in"
	ewarn "/etc/cups/ppd/, click on 'Modify Printer' belonging to the"
	ewarn "corresponding printer in the CUPS webinterface (usually"
	ewarn "reachable via http://localhost:631/) and choose the correct"
	ewarn "printer make and model, for example:"
	ewarn "'Samsung' -> 'Samsung ML-1610, 1.0 (en)'"
}
