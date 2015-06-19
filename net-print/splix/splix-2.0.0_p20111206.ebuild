# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/splix/splix-2.0.0_p20111206.ebuild,v 1.3 2012/03/12 19:10:48 scarabeus Exp $

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="A set of CUPS printer drivers for SPL (Samsung Printer Language) printers"
HOMEPAGE="http://splix.sourceforge.net/"
SRC_URI="http://dev.gentoo.org/~voyageur/distfiles/${P}.tar.bz2
	http://dev.gentooexperimental.org/~scarabeus/samsung-cms-20120312.tar.xz"

# If you can't find your printer cms open the new bug if you recheck the
# cms home and it is contained there. Otherwise bummer.
# The cms can be found here:
#    http://www.bchemnet.com/suldr/smfpv3.html
# It is stored int he unifieddriver tarball and repacked.

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+jbig"

DEPEND=">=app-text/ghostscript-gpl-9.02
	>=net-print/cups-1.4.0
	jbig? ( media-libs/jbigkit )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	# Honor LDFLAGS
	sed -e "/[a-z]_LDFLAGS/s/:=.*/:= $\{LDFLAGS\}/" -i module.mk \
		|| die "module.mk sed failed"
	# Correct link comand, do not strip on install
	sed -e "s/g++/$\{LINKER\}/" -e "/install/s/-s //" -i rules.mk \
		|| die "rules.mk sed failed"
}

src_compile() {
	local options="MODE=optimized"
	use jbig || options="${options} DISABLE_JBIG=1"
	emake ${options} PSTORASTER=gstoraster CXX="$(tc-getCXX)" \
		OPTIM_CFLAGS="${CFLAGS}" OPTIM_CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install
	gzip "${ED}"/$(cups-config --datadir)/model/*/*.ppd || die "ppd gzip failed"

	# it is expected to be at:
	#    /usr/share/cups/profiles/{samsung,xerox,dell}
	# instead it is only at:
	#    /usr/share/cups/profiles/samsung
	emake DESTDIR="${D}" CMSDIR="${WORKDIR}"/cms MANUFACTURER=samsung installcms
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
