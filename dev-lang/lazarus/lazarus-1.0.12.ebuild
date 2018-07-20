# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

RESTRICT="strip" #269221

FPCVER="2.6.0"

SLOT="0" # Note: Slotting Lazarus needs slotting fpc, see DEPEND.
LICENSE="GPL-2 LGPL-2.1-with-linking-exception"
KEYWORDS="amd64 x86"
DESCRIPTION="Lazarus IDE is a feature rich visual programming environment emulating Delphi"
HOMEPAGE="https://www.lazarus-ide.org/"
IUSE="minimal"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/Lazarus%20Zip%20_%20GZip/Lazarus%20${PV}/${PN}-${PV}-0.tar.gz"

DEPEND=">=dev-lang/fpc-${FPCVER}[source]
	net-misc/rsync
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}
	!=gnome-base/librsvg-2.16.1"
DEPEND="${DEPEND}
	>=sys-devel/binutils-2.19.1-r1"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.9.26-fpcsrc.patch

	# Use default configuration (minus stripping) unless specifically requested otherwise
	if ! test ${PPC_CONFIG_PATH+set} ; then
		local FPCVER=$(fpc -iV)
		export PPC_CONFIG_PATH="${WORKDIR}"
		sed -e 's/^FPBIN=/#&/' /usr/lib/fpc/${FPCVER}/samplecfg |
			sh -s /usr/lib/fpc/${FPCVER} "${PPC_CONFIG_PATH}" || die
		#sed -i -e '/^-Xs/d' "${PPC_CONFIG_PATH}"/fpc.cfg || die
	fi
}

src_compile() {
	LCL_PLATFORM=gtk2 emake \
		$(usex minimal "" "bigide") \
		-j1
}

src_install() {
	diropts -m0755
	dodir /usr/share
	# Using rsync to avoid unnecessary copies and cleaning...
	# Note: *.o and *.ppu are needed
	rsync -a \
		--exclude="CVS"     --exclude=".cvsignore" \
		--exclude="*.ppw"   --exclude="*.ppl" \
		--exclude="*.ow"    --exclude="*.a"\
		--exclude="*.rst"   --exclude=".#*" \
		--exclude="*.~*"    --exclude="*.bak" \
		--exclude="*.orig"  --exclude="*.rej" \
		--exclude=".xvpics" --exclude="*.compiled" \
		--exclude="killme*" --exclude=".gdb_hist*" \
		--exclude="debian"  --exclude="COPYING*" \
		--exclude="*.app" \
		"${S}" "${ED%/}"/usr/share \
	|| die "Unable to copy files!"

	dosym ../share/lazarus/startlazarus /usr/bin/startlazarus
	dosym ../share/lazarus/startlazarus /usr/bin/lazarus
	dosym ../share/lazarus/lazbuild /usr/bin/lazbuild
	use minimal || dosym ../share/lazarus/components/chmhelp/lhelp/lhelp /usr/bin/lhelp
	dosym ../lazarus/images/ide_icon48x48.png /usr/share/pixmaps/lazarus.png

	make_desktop_entry startlazarus "Lazarus IDE" "lazarus" || die "Failed making desktop entry!"
}
